cask "open-transfer" do
  arch arm: "arm64", intel: "x64"

  version "3.2.4"
  sha256 arm:   "11cb9dddf12567dc3bee15514871fb2a61f5c7faf5c370035a30e895562a6c62",
         intel: "8e0632012656a57f0c110aaa7c0906eb1285a4e05868d43526239a14eb14ccf6"

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
