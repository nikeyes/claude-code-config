#!/usr/bin/env bash
set -euo pipefail

echo "🗑️  Uninstalling Claude Code Public Configuration"

# Remove Claude Code
rm -f ~/.local/bin/claude
rm -rf ~/.claude-code

# Remove public files
rm -f ~/.claude/CLAUDE.md
rm -f ~/.claude/statusline.sh
rm -f ~/.claude/switch-claude-config.sh
rm -rf ~/.claude/commands
rm -rf ~/.claude/settings-personal.json
rm -rf ~/.claude/marketplaces
rm -rf ~/.claude/plugins
rm -rf ~/.claude/skills

# Remove Codex compatibility bits
STEPWISE_CLONE=~/.claude/plugins/marketplaces/stepwise-dev
if [ -d "$STEPWISE_CLONE" ] && [ -f "$STEPWISE_CLONE/Makefile" ]; then
    (cd "$STEPWISE_CLONE" && make uninstall-codex) || true
fi
rm -f ~/.codex/AGENTS.md

echo "✅ Public configuration removed"
echo "ℹ️  Note: settings.json and profile files were not removed"
