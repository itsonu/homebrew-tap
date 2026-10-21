class OpenTransfer < Formula
  desc "Share files between nearby devices over Wi-Fi, like AirDrop"
  homepage "https://itsonu.github.io/open-transfer/"
  version "3.2.4"
  license "MIT"

  livecheck do
    url "https://github.com/itsonu/open-transfer"
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/itsonu/open-transfer/releases/download/v#{version}/open-transfer-macos-arm64-cli.tar.gz"
      sha256 "8e0e4873b521c33365b5e19ad5985b61c3e7ae3041943fa51e1da750339b270f"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/itsonu/open-transfer/releases/download/v#{version}/open-transfer-linux-x64.tar.gz"
      sha256 "8c12c3257d83e02e6583d2c1acc3e55bb644d13eb51c7bff0619f9c60b72d3da"
    end
  end

  def install
    bin.install "open-transfer"
  end

  service do
    run [opt_bin/"open-transfer"]
    keep_alive true
    log_path var/"log/open-transfer.log"
    error_log_path var/"log/open-transfer.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/open-transfer --version")
  end
end
