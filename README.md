# Mappa.ai Homebrew Tap

Official Homebrew tap for Mappa.ai tools.

## Requirements

- **macOS 14.6 (Sonoma)** or later for system audio recording
- macOS 14.0+ for input device recording only

## Installation

```bash
brew tap mappa-ai/tap
brew install recorder-rs
```

This will install **recorder-rs** - a headless audio recording service with HTTP API.

## Start the Service

```bash
brew services start recorder-rs
```

The service will now start automatically on login.

## Usage

### Service Management

```bash
# Start the service
brew services start recorder-rs

# Stop the service
brew services stop recorder-rs

# Restart the service
brew services restart recorder-rs

# Check service status
brew services info recorder-rs
```

### Viewing Logs

```bash
# View live logs
tail -f $(brew --prefix)/var/log/recorder-rs.log

# View error logs
tail -f $(brew --prefix)/var/log/recorder-rs.error.log
```

### API Endpoints

The service runs on `http://localhost:20432` with the following endpoints:

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/check-state` | GET | Check recorder state |
| `/recorder/start` | POST | Start recording |
| `/recorder/stop` | POST | Stop recording |
| `/flush` | POST | Upload recorded audio |
| `/delete` | DELETE | Delete recorded audio |

## Uninstalling

```bash
brew services stop recorder-rs
brew uninstall recorder-rs
```

## Troubleshooting

### Service won't start

Check the error log:
```bash
cat $(brew --prefix)/var/log/recorder-rs.error.log
```

### System audio recording not working

Ensure you are running macOS 14.6 or later. System audio recording uses native ScreenCaptureKit loopback which requires macOS 14.6+.

## Support

For issues and feature requests, please visit:
https://github.com/mappa-ai/recorder-rs/issues
