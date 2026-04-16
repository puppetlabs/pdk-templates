#!/usr/bin/env bash
# Shared helper: reads hook JSON from stdin and sets $cmd to the Bash tool command.
# Sources into each hook with: . "$(dirname "$0")/_parse_input.sh"
# Exits 0 (allow) if no JSON parser is available.

input=$(cat)

if command -v jq >/dev/null 2>&1; then
  cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // ""' 2>/dev/null || echo "")
elif command -v python3 >/dev/null 2>&1; then
  cmd=$(printf '%s' "$input" | python3 -c "import sys,json; print(json.load(sys.stdin).get('tool_input',{}).get('command',''))" 2>/dev/null || echo "")
else
  exit 0
fi
