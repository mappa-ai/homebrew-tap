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
  version "3.2.1"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://mappa-content-delivery-network.mappa.ai/releases/recorder-rs-aarch64-apple-darwin.tar.gz"
      sha256 "ceaab1de36c6bec2afa595618f92286189a19997e593b43ffd9413bf632d1a5a"
    end
    on_intel do
      url "https://mappa-content-delivery-network.mappa.ai/releases/recorder-rs-x86_64-apple-darwin.tar.gz"
      sha256 "8758d22f152ec67034e9e9bc36f8dc76d8d1f70f2291733b7f003fc9c3cfbefe"
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
