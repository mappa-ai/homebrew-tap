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
#   Start the service: brew services start recorder-rs
class RecorderRs < Formula
  desc "Headless audio recording service with HTTP API"
  homepage "https://github.com/mappa-ai/recorder-rs"
  version "3.0.2"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://mappa-content-delivery-network.mappa.ai/releases/recorder-rs-aarch64-apple-darwin.tar.gz"
      sha256 "dc751df28c9b1eea71dd44f3605acbe38073e7304d1305f3cf3cc086435590cd"
    end
    on_intel do
      url "https://mappa-content-delivery-network.mappa.ai/releases/recorder-rs-x86_64-apple-darwin.tar.gz"
      sha256 "8e718f381afb5647be93996d8f91d7eeb94d6438440eec2199e5271357ba1606"
    end
  end

  depends_on :macos
  depends_on macos: :sonoma # Requires macOS 14+ for native loopback

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

      NOTE: System audio recording requires macOS 14.6 or later.
            Input device recording works on macOS 14.0+.

      Start the service:
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
