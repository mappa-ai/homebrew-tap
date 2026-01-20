# typed: false
# frozen_string_literal: true

# Homebrew formula for recorder-rs
# Headless audio recording service with HTTP API for macOS
#
# Installation:
#   brew tap mappa-ai/tap
#   brew install recorder-rs
#
# After installation:
#   1. Reboot your Mac (required for BlackHole)
#   2. Configure Audio MIDI Setup (see caveats)
#   3. Start the service: brew services start recorder-rs
class RecorderRs < Formula
  desc "Headless audio recording service with HTTP API"
  homepage "https://github.com/mappa-ai/recorder-rs"
  version "1.1.3"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://mappa-content-delivery-network.mappa.ai/releases/recorder-rs-aarch64-apple-darwin.tar.gz"
      sha256 "da820219ec07bd183cddbbb6c53cce28ca32806b027c8be6b962e30786bafff0"
    end
    on_intel do
      url "https://mappa-content-delivery-network.mappa.ai/releases/recorder-rs-x86_64-apple-darwin.tar.gz"
      sha256 "bd707230e22abf286f8950b0ad07ea807df8c49778ac618f0081e37cbefc3c35"
    end
  end

  depends_on :macos
  depends_on "switchaudio-osx"

  def install
    bin.install "recorder-rs"
  end

  service do
    run [opt_bin/"recorder-rs"]
    keep_alive true
    log_path var/"log/recorder-rs.log"
    error_log_path var/"log/recorder-rs.error.log"
    environment_variables PATH: std_service_path_env
  end

  def caveats
    <<~EOS
      recorder-rs has been installed!

      IMPORTANT: After installation, you must complete these steps:

      1. Install BlackHole audio driver (if not already installed):
         brew install --cask blackhole-2ch

      2. REBOOT your Mac
         BlackHole audio driver requires a reboot to load properly.

      3. Configure Audio MIDI Setup:
         - Open "Audio MIDI Setup" (in /Applications/Utilities)
         - Click "+" at bottom left -> "Create Multi-Output Device"
         - Check your output device (speakers/headphones) AND "BlackHole 2ch"
         - Right-click the new device -> Rename to "mappa-recorder-device"

      4. Start the service:
         brew services start recorder-rs

      Service Management:
        brew services start recorder-rs    # Start service
        brew services stop recorder-rs     # Stop service
        brew services restart recorder-rs  # Restart service
        brew services info recorder-rs     # Check status

      View Logs:
        tail -f #{var}/log/recorder-rs.log
        tail -f #{var}/log/recorder-rs.error.log

      The API runs on http://localhost:20432
    EOS
  end

  test do
    # Verify the binary is executable
    assert_predicate bin/"recorder-rs", :executable?

    # Verify the binary runs and responds (will fail without audio devices, but shows it loads)
    output = shell_output("#{bin}/recorder-rs --version 2>&1", 1)
    # The binary doesn't have --version, so it will error, but this proves it executes
    assert_match(/error|usage|recorder/i, output.downcase)
  end
end
