cask "open-transfer" do
  arch arm: "arm64", intel: "x64"

  version "3.3.0"
  sha256 arm:   "f6b31f0c8716fcd702ed9a6267cf2af3745e1cc62b563624c00db34158d98dc4",
         intel: "014d2990e00183df995d7137f2c5a0fdf03b5f778505ceaa10a1f6df0144c0f6"

  url "https://github.com/itsonu/open-transfer/releases/download/v#{version}/open-transfer-macos-#{arch}.dmg"
  name "Open Transfer"
  desc "Share files between nearby devices over Wi-Fi, like AirDrop"
  homepage "https://itsonu.github.io/open-transfer/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on :macos

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
