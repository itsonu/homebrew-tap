# Homebrew tap for Open Transfer

[Open Transfer](https://github.com/itsonu/open-transfer) is AirDrop for every device: send files between Windows, Mac, Android, Linux and any browser on the same Wi‑Fi. No account, no cloud.

## Install

**Desktop app** (Mac, Apple silicon and Intel):

```bash
brew install --cask itsonu/tap/open-transfer
```

**Command-line app** (Mac and Linux x64; it opens in your browser):

```bash
brew install itsonu/tap/open-transfer
open-transfer
```

Run the command-line app in the background, starting at login:

```bash
brew services start itsonu/tap/open-transfer
```

## First launch on a Mac

The desktop app is **not notarized by Apple yet**, so macOS blocks it the first time. Open it once from **System Settings → Privacy & Security → Open Anyway**. Allow **local network** access when asked, so nearby devices can find it.

## Update or remove

```bash
brew upgrade itsonu/tap/open-transfer                # or: brew upgrade --cask itsonu/tap/open-transfer
brew uninstall --cask itsonu/tap/open-transfer       # received files stay in ~/Downloads/Open Transfer
```

## How this tap stays current

- `.github/workflows/update.yml` points the cask and formula at the latest release a few times a day, or right away when Open Transfer's release workflow notifies it.
- It reads each file's SHA-256 from the release's `SHA256SUMS`, so Homebrew refuses any download that doesn't match.
- `.github/workflows/test.yml` installs and runs both on Apple silicon, Intel Mac and Linux.

To update by hand: `python3 .github/scripts/update.py [vX.Y.Z]`.
