"""Point the cask and the formula at the latest Open Transfer release.

    python .github/scripts/update.py            # latest release
    python .github/scripts/update.py v3.2.4     # a given tag

Reads the release from the GitHub API and takes each file's SHA-256 from the
release's SHA256SUMS (or, for releases made before it existed, from the API's
asset digest). Rewrites Casks/open-transfer.rb and Formula/open-transfer.rb;
prints the version. Set GITHUB_TOKEN to avoid the API's anonymous rate limit.
"""

from __future__ import annotations

import json
import os
import sys
import urllib.request
from pathlib import Path

REPO = "itsonu/open-transfer"
ROOT = Path(__file__).resolve().parents[2]


def get(url: str) -> bytes:
    accept = {"Accept": "application/vnd.github+json"}
    request = urllib.request.Request(url, headers=accept)  # noqa: S310 - fixed https URLs
    if token := os.environ.get("GITHUB_TOKEN"):
        request.add_header("Authorization", f"Bearer {token}")
    with urllib.request.urlopen(request, timeout=60) as res:  # noqa: S310 - fixed https URLs
        return res.read()


def checksums(release: dict) -> dict[str, str]:
    """{asset name: sha256} for every asset of the release."""
    sums = {}
    for asset in release["assets"]:
        digest = asset.get("digest") or ""
        if digest.startswith("sha256:"):
            sums[asset["name"]] = digest.removeprefix("sha256:")
    listed = next((a for a in release["assets"] if a["name"] == "SHA256SUMS"), None)
    if listed:
        for line in get(listed["browser_download_url"]).decode().splitlines():
            if line.strip():
                sha, name = line.split(maxsplit=1)
                sums[name.lstrip("*")] = sha
    return sums


CASK = """\
cask "open-transfer" do
  arch arm: "arm64", intel: "x64"

  version "{version}"
  sha256 arm:   "{dmg_arm64}",
         intel: "{dmg_x64}"

  url "https://github.com/itsonu/open-transfer/releases/download/v#{{version}}/open-transfer-macos-#{{arch}}.dmg"
  name "Open Transfer"
  desc "Share files between nearby devices over Wi-Fi, like AirDrop"
  homepage "https://itsonu.github.io/open-transfer/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :big_sur"

  app "Open Transfer.app"

  uninstall quit: "io.github.itsonu.opentransfer"

  # Received files stay in ~/Downloads/Open Transfer.
  zap trash: [
    "~/Library/Caches/io.github.itsonu.opentransfer",
    "~/Library/Preferences/io.github.itsonu.opentransfer.plist",
    "~/Library/Saved Application State/io.github.itsonu.opentransfer.savedState",
    "~/Library/WebKit/io.github.itsonu.opentransfer",
  ]

  caveats <<~EOS
    Open Transfer is not notarized by Apple yet, so macOS blocks the first launch.
    Open it once from System Settings -> Privacy & Security -> "Open Anyway".
    Allow local network access when asked, so nearby devices can find it.
  EOS
end
"""

FORMULA_HEAD = """\
class OpenTransfer < Formula
  desc "Share files between nearby devices over Wi-Fi, like AirDrop"
  homepage "https://itsonu.github.io/open-transfer/"
  version "{version}"
  license "MIT"

  livecheck do
    url "https://github.com/itsonu/open-transfer"
    strategy :github_latest
  end
"""

FORMULA_TAIL = """
  def install
    bin.install "open-transfer"
  end

  service do
    run [opt_bin/"open-transfer", "--no-browser", "--no-qr"]
    keep_alive true
    log_path var/"log/open-transfer.log"
    error_log_path var/"log/open-transfer.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/open-transfer --version")
  end
end
"""

# (os, cpu, asset) for the command-line builds; a build a release lacks is left out.
CLI_BUILDS = [
    ("macos", "arm", "open-transfer-macos-arm64-cli.tar.gz"),
    ("macos", "intel", "open-transfer-macos-x64-cli.tar.gz"),
    ("linux", "intel", "open-transfer-linux-x64.tar.gz"),
]


def formula(version: str, sums: dict[str, str]) -> str:
    blocks: dict[str, list[str]] = {}
    for os_name, cpu, asset in CLI_BUILDS:
        if asset in sums:
            blocks.setdefault(os_name, []).append(
                f'    on_{cpu} do\n      url "https://github.com/itsonu/open-transfer/releases/download/'
                f'v#{{version}}/{asset}"\n      sha256 "{sums[asset]}"\n    end\n'
            )
    body = "".join(f"\n  on_{os_name} do\n{''.join(parts)}  end\n" for os_name, parts in blocks.items())
    return FORMULA_HEAD.format(version=version) + body + FORMULA_TAIL


def main() -> None:
    tag = sys.argv[1] if len(sys.argv) > 1 else None
    path = f"tags/{tag}" if tag else "latest"
    release = json.loads(get(f"https://api.github.com/repos/{REPO}/releases/{path}"))
    version = release["tag_name"].removeprefix("v")
    sums = checksums(release)
    missing = [n for n in ("open-transfer-macos-arm64.dmg", "open-transfer-macos-x64.dmg") if n not in sums]
    if missing:
        sys.exit(f"{release['tag_name']}: no SHA-256 for {', '.join(missing)}")
    (ROOT / "Casks" / "open-transfer.rb").write_text(
        CASK.format(
            version=version,
            dmg_arm64=sums["open-transfer-macos-arm64.dmg"],
            dmg_x64=sums["open-transfer-macos-x64.dmg"],
        )
    )
    (ROOT / "Formula" / "open-transfer.rb").write_text(formula(version, sums))
    print(version)


if __name__ == "__main__":
    main()
