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

echo "🏪 Installing Official Marketplaces"
# Add claude-plugins-official marketplace
if ! claude plugin marketplace list 2>/dev/null | grep -q "claude-plugins-official"; then
    claude plugin marketplace add anthropics/claude-plugins-official
else
    echo "ℹ️  Marketplace claude-plugins-official already added, skipping..."
fi

# Add claude-code-plugins marketplace
if ! claude plugin marketplace list 2>/dev/null | grep -q "claude-code-plugins"; then
    claude plugin marketplace add anthropics/claude-code
else
    echo "ℹ️  Marketplace claude-code-plugins already added, skipping..."
fi

echo "🔌 Installing Official Plugins"
# Install claude-md-management plugin
if ! claude plugin list 2>/dev/null | grep -q "claude-md-management"; then
    claude plugin install claude-md-management@claude-plugins-official
else
    echo "ℹ️  Plugin claude-md-management already installed, skipping..."
fi

# Install claude-code-setup plugin
if ! claude plugin list 2>/dev/null | grep -q "claude-code-setup"; then
    claude plugin install claude-code-setup@claude-plugins-official
else
    echo "ℹ️  Plugin claude-code-setup already installed, skipping..."
fi

# Install pyright-lsp plugin
if ! claude plugin list 2>/dev/null | grep -q "pyright-lsp"; then
    claude plugin install pyright-lsp@claude-plugins-official
else
    echo "ℹ️  Plugin pyright-lsp already installed, skipping..."
fi

echo "🔌 Installing Claude Code Stepwise-Dev Plugin"
# Add marketplace (only if not already added)
if ! claude plugin marketplace list 2>/dev/null | grep -q "stepwise-dev"; then
    claude plugin marketplace add nikeyes/stepwise-dev
else
    echo "ℹ️  Marketplace stepwise-dev already added, skipping..."
fi

# Install plugin (only if not already installed)
if ! claude plugin list 2>/dev/null | grep -q "stepwise-dev"; then
    claude plugin install stepwise-dev@stepwise-dev
else
    echo "ℹ️  Plugin stepwise-dev already installed, skipping..."
fi

echo "📋 Installing CLAUDE.md"
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

echo "⚙️ Installing Personal Settings"
gcp --backup=numbered ./settings-personal.json ~/.claude/settings-personal.json

echo ""
echo "✅ Claude Code public configuration installed successfully"
echo "🌟 If you want monitoring with Prometheus and Grafana:"
echo "  - Follow: https://github.com/nikeyes/claude-code-monitoring-guide"
echo ""