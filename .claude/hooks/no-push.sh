#!/usr/bin/env bash
# Project rule: never push to GitHub without explicit permission granted each time.
# Asks (does not hard-block) on every: git push
# Uses a stricter, force-push-specific message when --force/-f is present.

# shellcheck source=/dev/null
. "$(dirname "$0")/_parse_input.sh"

if echo "$cmd" | grep -qE '(^|[;&|`(])[[:space:]]*(([[:alpha:]_][[:alnum:]_]*=[^[:space:]]*[[:space:]]+)*)([^[:space:]]*/)?git[[:space:]]+push([[:space:]]|$|[;&|])'; then
  if echo "$cmd" | grep -qE -- '(--force|--force-with-lease(=[^[:space:]]*)?|-[a-zA-Z]*f[a-zA-Z]*)([[:space:]]|$)'; then
    reason="Project rule: force-push requires explicit confirmation each time — never assume it's wanted."
  else
    reason="Project rule: pushing to GitHub requires your direct permission every time — it cannot be inferred from being asked to commit."
  fi
  echo "{\"systemMessage\":\"⚠️ $reason\",\"hookSpecificOutput\":{\"hookEventName\":\"PreToolUse\",\"permissionDecision\":\"ask\",\"permissionDecisionReason\":\"$reason\"}}"
fi
