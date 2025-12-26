#!/usr/bin/env bash
set -euo pipefail

echo "🌟 Installing Claude Code Public Configuration"

# Check if Claude Code is installed
if ! command -v claude &> /dev/null; then
    echo "⚠️  Claude Code is not installed. Installing now..."
    curl -fsSL https://claude.ai/install.sh | bash
fi

# Create .claude directory if it doesn't exist
mkdir -p ~/.claude

echo "📋 Installing TDD Guidelines"
gcp --backup=numbered ./CLAUDE.md ~/.claude/CLAUDE.md

echo "📊 Installing Custom Status Line"
gcp --backup=numbered ./statusline.sh ~/.claude/statusline.sh
chmod +x ~/.claude/statusline.sh

echo "🔄 Installing Profile Switcher"
gcp --backup=numbered ./switch-claude-config.sh ~/.claude/switch-claude-config.sh
chmod +x ~/.claude/switch-claude-config.sh

echo "🎯 Installing Custom Commands"
mkdir -p ~/.claude/commands
gcp --backup=numbered ./commands/*.md ~/.claude/commands/

echo ""
echo "✅ Claude Code public configuration installed successfully"
echo ""
echo "📝 What was installed:"
echo "   - TDD development guidelines (CLAUDE.md)"
echo "   - Custom status line script"
echo "   - Profile switcher utility"
echo "   - Custom commands (nikeyes-*)"
echo ""
echo "💡 Next steps:"
echo "   - For company-specific setup, run the private repo installer"
echo "   - Configure your settings.json or use profile switching"
echo ""
