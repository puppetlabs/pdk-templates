#!/usr/bin/env bash
# Project rule: never delete a file without explicit permission.
# Asks (does not hard-block) on: rm, sudo rm, xargs rm, /bin/rm, /usr/bin/rm
# (and similar absolute paths), and git rm.
# Does not cover: find -exec rm (rm as a subprocess argument, not a shell token).

# shellcheck source=/dev/null
. "$(dirname "$0")/_parse_input.sh"

reason="Project rule: file deletion requires explicit permission each time."

if echo "$cmd" | grep -qE '(^|[;&|])[[:space:]]*(sudo[[:space:]]+|xargs[[:space:]]+)?([^[:space:]]*/)?rm([[:space:]]|$)' \
  || echo "$cmd" | grep -qE '(^|[;&|`(])[[:space:]]*(([[:alpha:]_][[:alnum:]_]*=[^[:space:]]*[[:space:]]+)*)([^[:space:]]*/)?git[[:space:]]+rm([[:space:]]|$|[;&|])'; then
  echo "{\"systemMessage\":\"⚠️ $reason\",\"hookSpecificOutput\":{\"hookEventName\":\"PreToolUse\",\"permissionDecision\":\"ask\",\"permissionDecisionReason\":\"$reason\"}}"
fi
