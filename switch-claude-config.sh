#!/bin/bash
set -euo pipefail

# Script to switch Claude Code configuration
# Usage: switch-claude-config.sh [personal|company]

CLAUDE_DIR="${HOME}/.claude"
PROFILE="${1}"

if [[ "${PROFILE}" != "personal" && "${PROFILE}" != "company" ]]; then
    echo "❌ Usage: ${0} [personal|company]"
    exit 1
fi

SOURCE_FILE="${CLAUDE_DIR}/settings-${PROFILE}.json"
TARGET_FILE="${CLAUDE_DIR}/settings.json"

if [[ ! -f "${SOURCE_FILE}" ]]; then
    echo "❌ Not found: ${SOURCE_FILE}"
    exit 1
fi

cp "${SOURCE_FILE}" "${TARGET_FILE}"

echo "✅ Configuration switched to: ${PROFILE}"

# Herdr registers its own SessionStart hook in settings.json, which the copy
# above overwrites. Let Herdr re-declare it rather than duplicating its hook
# shape (and version) in the profile files.
if command -v herdr &> /dev/null; then
    herdr integration install claude
fi
