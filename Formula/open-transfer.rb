class OpenTransfer < Formula
  desc "Share files between nearby devices over Wi-Fi, like AirDrop"
  homepage "https://itsonu.github.io/open-transfer/"
  version "3.2.5"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/itsonu/open-transfer/releases/download/v#{version}/open-transfer-macos-arm64-cli.tar.gz"
      sha256 "5bd2f7fbee5c800403572b3abe997eee6c75ee8e8783d13e8d3ba89fe60272e3"
    end
    on_intel do
      url "https://github.com/itsonu/open-transfer/releases/download/v#{version}/open-transfer-macos-x64-cli.tar.gz"
      sha256 "5ce7835d568bb84d547d5891596485c564cd3ea3a55a3921bba4d6f06fbbbbb7"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/itsonu/open-transfer/releases/download/v#{version}/open-transfer-linux-x64.tar.gz"
      sha256 "01d5309cece25acb0431effd2b326e4a1a5d9d3c8f8cf64f0ecff9bd5d0467af"
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
