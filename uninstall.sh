#!/usr/bin/env bash
set -euo pipefail

echo "🗑️  Uninstalling Claude Code Public Configuration"

# Remove public files
rm -f ~/.claude/CLAUDE.md
rm -f ~/.claude/statusline.sh
rm -f ~/.claude/switch-claude-config.sh
rm -rf ~/.claude/commands

echo "✅ Public configuration removed"
echo "ℹ️  Note: settings.json and profile files were not removed"
