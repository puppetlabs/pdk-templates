#!/usr/bin/env bash
# Project rule: never merge a pull request.
# Blocks: gh pr merge

# shellcheck source=/dev/null
. "$(dirname "$0")/_parse_input.sh"

if echo "$cmd" | grep -qE '(^|[;&|])[[:space:]]*gh pr merge'; then
  echo '{"systemMessage":"🚫 Project rule: never merge a pull request.","hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"Project rule: never merge a pull request."}}'
fi
