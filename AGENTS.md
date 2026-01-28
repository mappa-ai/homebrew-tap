# AGENTS.md - Homebrew Tap Repository Guide

This document provides instructions for AI coding agents working in this Homebrew tap repository.

## Repository Overview

This is a Homebrew tap (`mappa-ai/tap`) containing formulas for Mappa.ai tools. The primary formula is `recorder-rs`, a headless audio recording service for macOS.

```
homebrew-tap/
├── Formula/
│   └── recorder-rs.rb      # Homebrew formula (Ruby)
├── .github/workflows/
│   └── update-formula.yml  # CI automation
├── README.md
└── AGENTS.md
```

## Build/Lint/Test Commands

```bash
# Validate Ruby syntax (required before committing)
ruby -c Formula/recorder-rs.rb

# Lint with strict mode
brew audit --strict recorder-rs

# Style check (rubocop-based)
brew style Formula/recorder-rs.rb

# Run formula test block
brew test recorder-rs
brew test -v recorder-rs          # verbose

# Install from local formula
brew install --build-from-source Formula/recorder-rs.rb
brew reinstall Formula/recorder-rs.rb

# Debug installation
brew install -v --debug Formula/recorder-rs.rb
```

## Code Style Guidelines

### File Header (Required)
Every formula MUST start with these magic comments:
```ruby
# typed: false
# frozen_string_literal: true
```

### Documentation Header
```ruby
# Homebrew formula for <name>
# <Brief description>
#
# Installation:
#   brew tap mappa-ai/tap
#   brew install <name>
```

### Formula Structure Order
Follow this exact order:
1. `desc` - Short description
2. `homepage` - Project URL
3. `version` - Version string
4. `license` - License identifier
5. Platform blocks (`on_macos do ... end`)
6. `depends_on` declarations
7. `def install` method
8. `service` block (if applicable)
9. `def caveats` method (if applicable)
10. `test` block

### Naming Conventions
- **Filename:** lowercase with hyphens (e.g., `recorder-rs.rb`)
- **Class name:** CamelCase (e.g., `RecorderRs`)

### String Formatting
- Use double quotes: `"string"`
- Heredocs for multi-line:
```ruby
def caveats
  <<~EOS
    Text here. Interpolation: #{var}/log/file.log
  EOS
end
```

### Platform-Specific Code
```ruby
on_macos do
  on_arm do
    url "https://..."
    sha256 "..."
  end
  on_intel do
    url "https://..."
    sha256 "..."
  end
end
```

### Dependencies (in order)
```ruby
depends_on :macos                    # Platform first
depends_on "formula-name"            # Formulas
depends_on cask: "cask-name"         # Casks last
```

### SHA256 Hashes
- Lowercase hex, 64 characters
- Validate: `^[a-f0-9]{64}$`

### Test Blocks
```ruby
test do
  assert_predicate bin/"binary-name", :executable?
  output = shell_output("#{bin}/binary-name --help 2>&1", 0)
  assert_match(/expected-output/i, output)
end
```

### Error Handling
- `odie "message"` - Fatal errors
- `opoo "message"` - Warnings
- `ohai "message"` - Info

## Version Updates

Versions update automatically via CI when upstream releases. The workflow:
1. Receives `repository_dispatch` with version + SHA256 hashes
2. Updates formula using sed
3. Validates Ruby syntax
4. Commits and pushes

Manual update: Change `version` and `sha256` fields directly.

## CI/CD

- **Trigger:** `repository_dispatch` or manual `workflow_dispatch`
- **Validation:** `ruby -c Formula/recorder-rs.rb`
- **Secret:** `HOMEBREW_TAP_TOKEN` (repo write access)

## Adding a New Formula

1. Create `Formula/<name>.rb` with required structure
2. Add header comments
3. Test: `brew install --build-from-source Formula/<name>.rb`
4. Lint: `brew audit --strict <name>`
5. Validate: `ruby -c Formula/<name>.rb`

## Service Debugging

```bash
# View logs
tail -f $(brew --prefix)/var/log/recorder-rs.log
tail -f $(brew --prefix)/var/log/recorder-rs.error.log

# Check launchd
launchctl list | grep recorder
```

## Important Notes

- macOS 14.6+ required for system audio recording (uses native ScreenCaptureKit loopback)
- macOS 14.0+ required for input device recording
- Binaries hosted on mappa CDN (pre-compiled)
- Service runs on `http://localhost:20432`
