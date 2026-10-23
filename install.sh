#!/usr/bin/env bash
set -euo pipefail

echo "🌟 Installing Claude Code Public Configuration"

# GNU cp is `gcp` on macOS (Homebrew coreutils) and plain `cp` on Linux
if command -v gcp &> /dev/null; then
    GNU_CP="gcp"
else
    GNU_CP="cp"
fi

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

echo "🔌 Installing Official Plugins (disabled by default, enable as needed)"
# Install claude-md-management plugin (disabled by default)
if ! claude plugin list 2>/dev/null | grep -q "claude-md-management"; then
    claude plugin install claude-md-management@claude-plugins-official
else
    echo "ℹ️  Plugin claude-md-management already installed, skipping..."
fi
claude plugin disable claude-md-management 2>/dev/null || true

# Install claude-code-setup plugin (disabled by default)
if ! claude plugin list 2>/dev/null | grep -q "claude-code-setup"; then
    claude plugin install claude-code-setup@claude-plugins-official
else
    echo "ℹ️  Plugin claude-code-setup already installed, skipping..."
fi
claude plugin disable claude-code-setup 2>/dev/null || true

# Install skill creator plugin
if ! claude plugin list 2>/dev/null | grep -q "skill-creator"; then
    claude plugin install skill-creator@claude-plugins-official
else
    echo "ℹ️  Plugin skill-creator already installed, skipping..."
fi

# Install pyright-lsp plugin
# Ubuntu blocks system-wide pip (PEP 668), so fall back to npm there
if command -v pyright &> /dev/null; then
    echo "ℹ️  pyright already installed, skipping..."
elif command -v pip &> /dev/null; then
    pip install pyright
elif command -v npm &> /dev/null; then
    npm install -g --prefix ~/.local pyright
else
    echo "⚠️  Neither pip nor npm found, skipping pyright"
fi

if ! claude plugin list 2>/dev/null | grep -q "pyright-lsp"; then
    claude plugin install pyright-lsp@claude-plugins-official
else
    echo "ℹ️  Plugin pyright-lsp already installed, skipping..."
fi

# Install chrome-devtools-mcp plugin (disabled by default; now published in
# claude-plugins-official, no separate ChromeDevTools marketplace needed)
if ! claude plugin list 2>/dev/null | grep -q "chrome-devtools-mcp"; then
    claude plugin install chrome-devtools-mcp@claude-plugins-official
else
    echo "ℹ️  Plugin chrome-devtools-mcp already installed, skipping..."
fi
claude plugin disable chrome-devtools-mcp 2>/dev/null || true

echo "🔌 Installing Claude Code Stepwise-Dev Plugins"
# Add marketplace (only if not already added)
if ! claude plugin marketplace list 2>/dev/null | grep -q "stepwise-dev"; then
    claude plugin marketplace add nikeyes/stepwise-dev
else
    echo "ℹ️  Marketplace stepwise-dev already added, skipping..."
fi

# Install each stepwise sub-plugin individually
for stepwise_plugin in stepwise-web stepwise-core stepwise-git; do
    if ! claude plugin list 2>/dev/null | grep -q "^${stepwise_plugin}"; then
        claude plugin install "${stepwise_plugin}@stepwise-dev"
    else
        echo "ℹ️  Plugin ${stepwise_plugin} already installed, skipping..."
    fi
done

echo "📋 Installing CLAUDE.md"
"$GNU_CP" --backup=numbered ./CLAUDE.md ~/.claude/CLAUDE.md

echo "📋 Installing AGENTS.md (Codex)"
mkdir -p ~/.codex
"$GNU_CP" --backup=numbered ./AGENTS.md ~/.codex/AGENTS.md

echo "🔌 Enabling stepwise-dev skills/agents for Codex"
STEPWISE_CLONE=~/.claude/plugins/marketplaces/stepwise-dev
if [ -d "$STEPWISE_CLONE" ] && [ -f "$STEPWISE_CLONE/Makefile" ]; then
    (cd "$STEPWISE_CLONE" && make install-codex)
else
    echo "ℹ️  stepwise-dev marketplace clone not found at $STEPWISE_CLONE — skipping Codex install"
fi

echo "🐑 Installing Herdr"
# Terminal workspace manager used as the front-end for Claude Code
if ! command -v herdr &> /dev/null; then
    curl -fsSL https://herdr.dev/install.sh | sh
else
    echo "ℹ️  Herdr already installed, skipping..."
fi

# Pin the update channel so the repo, not the machine, is the source of truth
herdr channel set stable

echo "⚙️ Installing Herdr Configuration"
mkdir -p ~/.config/herdr
"$GNU_CP" --backup=numbered ./herdr-config.toml ~/.config/herdr/config.toml

echo "🪝 Installing Herdr agent-state hooks"
# Not idempotent-by-skip on purpose: hooks are versioned and drift behind the
# binary, so reinstall them on every run to keep them current.
herdr integration install claude
if command -v codex &> /dev/null; then
    herdr integration install codex
else
    echo "ℹ️  Codex not installed, skipping its Herdr hooks..."
fi

# Pick up the new config.toml if a server is already running
herdr server reload-config 2>/dev/null || true

echo "📊 Installing Custom Status Line"
"$GNU_CP" --backup=numbered ./statusline.sh ~/.claude/statusline.sh
chmod +x ~/.claude/statusline.sh

echo "🔄 Installing Profile Switcher"
"$GNU_CP" --backup=numbered ./switch-claude-config.sh ~/.claude/switch-claude-config.sh
chmod +x ~/.claude/switch-claude-config.sh

echo "⚙️ Installing Personal Settings"
"$GNU_CP" --backup=numbered ./settings-personal.json ~/.claude/settings-personal.json

echo ""
echo "✅ Claude Code public configuration installed successfully"
echo "🌟 If you want monitoring with Prometheus and Grafana:"
echo "  - Follow: https://github.com/nikeyes/claude-code-monitoring-guide"
echo ""