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
