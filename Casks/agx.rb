# Source-of-truth Homebrew cask for agx. scripts/release.sh seeds this into
# ryuldashev/homebrew-agx (Casks/agx.rb) on first publish and rewrites the
# version + sha256 lines on every release.
cask "agx" do
  version "0.25.0"
  sha256 "f7448c20a56fdbed3dddec60829635e33d9f299e18fcf614f0f38d4b5110d2ea"

  url "https://github.com/ryuldashev/agx/releases/download/v#{version}/agx-#{version}.dmg"
  name "agx"
  desc "Native macOS terminal for running many coding agents at once (fork of agterm)"
  homepage "https://github.com/ryuldashev/agx"

  depends_on macos: :sonoma
  depends_on arch: :arm64

  app "agx.app"
  binary "#{appdir}/agx.app/Contents/MacOS/agtermctl", target: "agtermctl"
  binary "#{appdir}/agx.app/Contents/Resources/agx", target: "agx"

  # strip Homebrew's com.apple.quarantine so brew install/upgrade opens with no
  # "downloaded from the internet" prompt. the app is Developer ID signed, notarized,
  # and stapled, but Gatekeeper still shows the first-launch confirm whenever the
  # quarantine attr is present, and brew re-stamps it on every fresh bundle.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/agx.app"],
                   sudo: false
  end

  zap trash: [
    "~/Library/Application Support/agx",
    "~/.config/agx",
  ]
end
