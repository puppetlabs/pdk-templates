#!/usr/bin/env bash
# Project rule: never push a branch without explicit instruction.
# Blocks: git push

. "$(dirname "$0")/_parse_input.sh"

if echo "$cmd" | grep -qE '^git push'; then
  echo '{"continue":false,"stopReason":"Project rule: never push a branch without explicit instruction."}'
fi
