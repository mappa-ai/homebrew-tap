# Mappa.ai Homebrew Tap

Official Homebrew tap for Mappa.ai tools.

## Installation

```bash
brew tap mappa-ai/tap
brew install recorder-rs
```

This will automatically install:
- **recorder-rs** - Headless audio recording service
- **switchaudio-osx** - Audio device switcher (dependency)
- **blackhole-2ch** - Virtual audio driver (dependency)

## Post-installation Setup

### 1. Reboot Required

**You must reboot your Mac** after installation for the BlackHole audio driver to load.

### 2. Configure Audio MIDI Setup

After rebooting:

1. Open **Audio MIDI Setup** (in `/Applications/Utilities/`)
2. Click **"+"** at bottom left -> **"Create Multi-Output Device"**
3. Check both:
   - Your output device (speakers/headphones)
   - **BlackHole 2ch**
4. Right-click the new device -> **Rename to "mappa-recorder-device"**

### 3. Start the Service

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

To also remove dependencies:
```bash
brew uninstall switchaudio-osx
brew uninstall --cask blackhole-2ch
```

## Troubleshooting

### "SwitchAudioSource not found"

```bash
brew install switchaudio-osx
```

### "BlackHole not found" after installation

1. Make sure you've rebooted after installing
2. Check if BlackHole appears in Audio MIDI Setup
3. Try reinstalling: `brew reinstall --cask blackhole-2ch`

### Service won't start

Check the error log:
```bash
cat $(brew --prefix)/var/log/recorder-rs.error.log
```

### Recording has no audio

1. Verify the Multi-Output Device is configured correctly
2. Ensure it's named exactly `mappa-recorder-device`
3. Check that BlackHole 2ch is checked in the Multi-Output Device

## Support

For issues and feature requests, please visit:
https://github.com/mappa-ai/recorder-rs/issues
