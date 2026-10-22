cask "open-transfer" do
  arch arm: "arm64", intel: "x64"

  version "3.2.5"
  sha256 arm:   "389e07ce86aaeb9d84e67d36267b4e48d745f59185da37f6ba6e2e860a40d5b2",
         intel: "b4dc6fcbb6e7b190d4db7fc6547148e8249c1b5a1e0ba9358abcf3e4399cd132"

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
