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
rm -rf ~/.claude/hooks

echo "🦀 Uninstalling RTK (Rust Token Killer)"
if command -v rtk &> /dev/null; then
    rtk init -g --uninstall 2>/dev/null || true
fi
rm -rf "${XDG_CONFIG_HOME:-$HOME/.config}/rtk"

SHELL_RC="${ZDOTDIR:-$HOME}/.zshrc"
if grep -q "RTK_TELEMETRY_DISABLED" "${SHELL_RC}" 2>/dev/null; then
    grep -v "RTK_TELEMETRY_DISABLED" "${SHELL_RC}" > "${SHELL_RC}.tmp" && mv "${SHELL_RC}.tmp" "${SHELL_RC}"
    echo "ℹ️  Removed RTK_TELEMETRY_DISABLED from ${SHELL_RC}"
fi

if command -v brew &> /dev/null && brew list rtk 2>/dev/null | grep -q rtk; then
    brew uninstall rtk || true
elif [ -f "${HOME}/.local/bin/rtk" ]; then
    rm -f "${HOME}/.local/bin/rtk"
fi

echo "✅ Public configuration removed"
echo "ℹ️  Note: settings.json and profile files were not removed"
