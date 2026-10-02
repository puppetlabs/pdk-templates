#!/usr/bin/env bash
# Project rule: never work directly on the main or master branch.
# Blocks: git commit or git push when current branch is main or master.

# shellcheck source=/dev/null
. "$(dirname "$0")/_parse_input.sh"

if echo "$cmd" | grep -qE '(^|[;&|`(])[[:space:]]*(([[:alpha:]_][[:alnum:]_]*=[^[:space:]]*[[:space:]]+)*)([^[:space:]]*/)?git[[:space:]]+(commit|push)([[:space:]]|$|[;&|])'; then
  branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  if [ "$branch" = "main" ] || [ "$branch" = "master" ]; then
    reason="Project rule: never work directly on the $branch branch — commit/push blocked."
    echo "{\"systemMessage\":\"🚫 $reason\",\"hookSpecificOutput\":{\"hookEventName\":\"PreToolUse\",\"permissionDecision\":\"deny\",\"permissionDecisionReason\":\"$reason\"}}"
  fi
fi
