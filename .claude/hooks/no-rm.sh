#!/usr/bin/env bash
# Project rule: never delete a file without explicit permission.
# Blocks: rm as the leading command token after a shell separator.
# Does not cover sudo rm, /bin/rm, or find -exec rm variants.

. "$(dirname "$0")/_parse_input.sh"

if echo "$cmd" | grep -qE '(^|[;&|])[[:space:]]*rm([[:space:]]|$)'; then
  echo '{"continue":false,"stopReason":"Project rule: never delete a file without explicit permission."}'
fi
