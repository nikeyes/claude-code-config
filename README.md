# Claude Code Public Configuration

Shareable configuration with CLAUDE.md, custom commands, and utilities.

## Components

**Core Files:**
- `CLAUDE.md` - My personal rules for all projects
- `settings-personal.json` - Personal configuration with local telemetry
- `statusline.sh` - Context usage status bar with color-coded progress
- `switch-claude-config.sh` - Profile switcher if you have personal Claude Code licence and company Claude Code licence
- `herdr-config.toml` - [Herdr](https://herdr.dev) terminal workspace manager used as the Claude Code front-end (theme, sidebar layout, agent-state hooks)

**Plugins:**
- Stepwise-Dev - Advanced workflow plugin: [https://github.com/nikeyes/stepwise-dev](https://github.com/nikeyes/stepwise-dev)

**Commands:**
- `nikeyes-understand` - Project structure analysis
- `nikeyes-security-scan` - Security analysis
- `nikeyes-refactoring-codebase` - Codebase refactoring
- `nikeyes-legacy-modernization` - Legacy code modernization

**Skills:**
- `test-desiderata` - Test quality analysis based on Kent Beck's Test Desiderata. Based on the work of [@eferro](https://github.com/eferro) — thanks for sharing it! Original skill: [https://github.com/eferro/augmentedcode-skills](https://github.com/eferro/augmentedcode-skills)

## Installation

### Requirements
- GNU cp (`gcp`) and `jq`

The installer also sets up [Herdr](https://herdr.dev/docs/install/) (installed to
`~/.local/bin/herdr` if missing), copies `herdr-config.toml` to
`~/.config/herdr/config.toml`, and installs its agent-state hooks for Claude Code
and Codex. The hooks are versioned and drift behind the binary, so they are
reinstalled on every run; check them anytime with `herdr integration status`.

Herdr also registers a `SessionStart` hook directly in `~/.claude/settings.json`.
Because `switch-claude-config.sh` overwrites that file wholesale, it re-runs
`herdr integration install claude` after switching profiles — that way Herdr stays
the single source of truth for its own hook instead of the profile files carrying
a stale copy of it.

### Standalone
```bash
./install.sh
```

```bash
./uninstall.sh
```
