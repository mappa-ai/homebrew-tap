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
  version "3.0.0"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://mappa-content-delivery-network.mappa.ai/releases/recorder-rs-aarch64-apple-darwin.tar.gz"
      sha256 "f2a2f0113694c716c9ccf2fa6b8bcc95e1d10c477d5e63aa06ec56a88d73f043"
    end
    on_intel do
      url "https://mappa-content-delivery-network.mappa.ai/releases/recorder-rs-x86_64-apple-darwin.tar.gz"
      sha256 "7d23e1bd1174437a2519976d8634c05a251d2c512cb8f73bb7ecc711e7fe500f"
    end
  end

  depends_on :macos
  depends_on "switchaudio-osx"

  def install
    bin.install "recorder-rs"
  end

  service do
    run [opt_bin/"recorder-rs"]
    keep_alive always: true
    restart_delay 5
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
