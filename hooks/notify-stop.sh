#!/bin/bash

ACTIVE=$(osascript -e 'tell application "System Events" to get name of first process whose frontmost is true')

# Do not notify if the terminal or editor is already in focus
if [[ "$ACTIVE" == "iTerm2" || "$ACTIVE" == "Code" || "$ACTIVE" == "Electron" ]]; then
  exit 0
fi

osascript -e 'display notification "✅ Claude ha terminado de ejecutar la tarea" with title "Tarea Completada" subtitle "Claude Code" sound name "Hero"'
