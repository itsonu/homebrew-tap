class OpenTransfer < Formula
  desc "Share files between nearby devices over Wi-Fi, like AirDrop"
  homepage "https://itsonu.github.io/open-transfer/"
  version "3.3.0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/itsonu/open-transfer/releases/download/v#{version}/open-transfer-macos-arm64-cli.tar.gz"
      sha256 "7f931d420a762a2d6968feefdc6d777ffb1ea0505a86b33bdde9299cb717b588"
    end
    on_intel do
      url "https://github.com/itsonu/open-transfer/releases/download/v#{version}/open-transfer-macos-x64-cli.tar.gz"
      sha256 "1ca7d7e6a9fe72531e54578c5cbf28b068f6d780a5ef376e3214fcf01b8eb7f7"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/itsonu/open-transfer/releases/download/v#{version}/open-transfer-linux-x64.tar.gz"
      sha256 "085fe06e508f27add80ebefd479c01192dcd5914d99092bbd1ec30954e88d630"
    end
  end

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
