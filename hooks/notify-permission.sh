#!/bin/bash

ACTIVE=$(osascript -e 'tell application "System Events" to get name of first process whose frontmost is true')

# Do not notify if the terminal or editor is already in focus
if [[ "$ACTIVE" == "iTerm2" || "$ACTIVE" == "Code" || "$ACTIVE" == "Electron" ]]; then
  exit 0
fi

osascript -e 'display notification "⚠️ Claude needs your approval to proceed" with title "Permission Required" subtitle "Claude Code" sound name "Funk"'
