# Claude Code Public Configuration

Public, shareable configuration for Claude Code including TDD guidelines, custom commands, and utility scripts.

## What's Included

- **CLAUDE.md** - TDD development guidelines and best practices
- **statusline.sh** - Custom status line showing context usage with color-coded progress bar
- **switch-claude-config.sh** - Utility to switch between configuration profiles
- **commands/** - Custom Claude Code commands:
  - `nikeyes-understand` - Understand project structure
  - `nikeyes-security-scan` - Security analysis
  - `nikeyes-refactoring-codebase` - Codebase refactoring
  - `nikeyes-legacy-modernization` - Legacy code modernization

## Installation

### Standalone Installation

```bash
cd ~/mordor/personal/claude-code-config
./install.sh
```

This installs the public components to `~/.claude/`.

### With Company Configuration

If you have a private repository with company-specific settings:

```bash
# Step 1: Install public config
cd ~/mordor/personal/claude-code-config
./install.sh

# Step 2: Install company config
cd ~/path/to/private/repo
./install.sh claude-code
```

## What's NOT Included

This repository does NOT include:
- Company-specific AWS Bedrock configurations
- API keys or credentials
- Private settings files
- Company-specific installation scripts

## File Structure

```
claude-code-config/
├── README.md                     # This file
├── install.sh                    # Standalone installer
├── uninstall.sh                  # Uninstaller
├── CLAUDE.md                     # TDD guidelines
├── statusline.sh                 # Status bar script
├── statusline-test.sh            # Test script
├── switch-claude-config.sh       # Profile switcher
└── commands/                     # Custom commands
    ├── nikeyes-understand.md
    ├── nikeyes-security-scan.md
    ├── nikeyes-refactoring-codebase.md
    └── nikeyes-legacy-modernization.md
```

## Requirements

- Claude Code installed (`curl -fsSL https://claude.ai/install.sh | bash`)
- `gcp` command (GNU cp with backup support)
- `jq` for statusline script
- `bash` and standard Unix utilities

## License

[Your license choice]
