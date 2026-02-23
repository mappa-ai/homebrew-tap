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
  version "3.2.2"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://mappa-content-delivery-network.mappa.ai/releases/recorder-rs-aarch64-apple-darwin.tar.gz"
      sha256 "b735f360003533d0b00374024b2eaec75dbf33d6283602312116707a6885ec42"
    end
    on_intel do
      url "https://mappa-content-delivery-network.mappa.ai/releases/recorder-rs-x86_64-apple-darwin.tar.gz"
      sha256 "26509d21c2da81d3a8b454eeeb2b2caf0dc4019776430e16f69b62f1821ee7e9"
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
