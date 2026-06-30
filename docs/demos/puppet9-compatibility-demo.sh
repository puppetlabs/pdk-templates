#!/usr/bin/env bash
#
# puppet9-compatibility-demo.sh
#
# Self-verifying demo for CAT-2683: shows Puppet 9 / Ruby 4 compatibility
# problems being caught (or missed) by `pdk validate ruby`, then shows the
# corrected code passing.
#
# It scaffolds a throwaway module against a pdk-templates ref that ships the
# compatibility cops, injects "bad" code for each issue, runs validation,
# applies the fix, and re-runs validation. The script asserts the expected
# pass/fail outcome at each step and exits non-zero if reality disagrees, so
# it doubles as a regression check for the cops.
#
# Usage:
#   docs/demos/puppet9-compatibility-demo.sh [TEMPLATE_URL] [TEMPLATE_REF]
#
# Defaults:
#   TEMPLATE_URL  file://<this repo>          (the checkout you run from)
#   TEMPLATE_REF  CAT-1698-rubocop-templates  (ref that scaffolds clean AND
#                                              ships all the cops; see the
#                                              accompanying .md walkthrough)
#
# Requirements: pdk on PATH (tested with pdk 3.7.0 -> Ruby 3.2.11), git.

set -euo pipefail

# --- resolve the repo root (so the file:// template URL is self-referential) -
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

TEMPLATE_URL="${1:-file://${REPO_ROOT}}"
TEMPLATE_REF="${2:-CAT-1698-rubocop-templates}"

WORKDIR="$(mktemp -d "${TMPDIR:-/tmp}/pdk9demo.XXXXXX")"
MODULE="demo_mod"
MODULE_DIR="${WORKDIR}/${MODULE}"

bold()  { printf '\033[1m%s\033[0m\n' "$*"; }
green() { printf '\033[32m%s\033[0m\n' "$*"; }
red()   { printf '\033[31m%s\033[0m\n' "$*"; }
rule()  { printf '%s\n' "----------------------------------------------------------------------"; }

# Run `pdk validate ruby` and assert the exit status.
#   assert_validate <expect: pass|fail> <human label>
assert_validate() {
  local expect="$1" label="$2" rc=0
  bold ">> pdk validate ruby   (${label})"
  ( cd "${MODULE_DIR}" && pdk validate ruby ) && rc=$? || rc=$?
  rule
  if [[ "${expect}" == "pass" ]]; then
    if [[ ${rc} -eq 0 ]]; then green "PASS as expected (exit ${rc})"; else
      red "EXPECTED PASS but validation failed (exit ${rc})"; exit 1; fi
  else
    if [[ ${rc} -ne 0 ]]; then green "FAILED as expected (exit ${rc})"; else
      red "EXPECTED FAILURE but validation passed (exit ${rc})"; exit 1; fi
  fi
  echo
}

trap 'echo; bold "Scratch module left at: ${MODULE_DIR}"' EXIT

bold "Puppet 9 / Ruby 4 compatibility demo"
echo "template-url: ${TEMPLATE_URL}"
echo "template-ref: ${TEMPLATE_REF}"
echo "workdir:      ${WORKDIR}"
echo

# --- 0. scaffold a fresh module --------------------------------------------
bold "STEP 0  Scaffold a fresh module (should validate clean: no lib/*.rb yet)"
( cd "${WORKDIR}" && pdk new module "${MODULE}" \
    --template-url="${TEMPLATE_URL}" \
    --template-ref="${TEMPLATE_REF}" \
    --skip-interview )
echo
assert_validate pass "empty scaffold"

mkdir -p "${MODULE_DIR}/lib/facter" "${MODULE_DIR}/spec/unit"

# ===========================================================================
# Issue #1 -- Kernel.open pipe subprocess   (cop: Security/Open)
#   Ruby 4 removes pipe-prefixed strings to Kernel#open (Ruby #19630).
# ===========================================================================
bold "ISSUE #1  Kernel.open pipe subprocess  ->  cop Security/Open"

cat > "${MODULE_DIR}/lib/facter/disk_usage.rb" <<'RUBY'
# frozen_string_literal: true

Facter.add(:disk_usage) do
  setcode do
    # BAD: the '|' prefix makes Kernel#open spawn a subprocess. Removed in Ruby 4.
    output = open('| df -h /').read
    output.split("\n").last.split[4]
  end
end
RUBY
assert_validate fail "issue #1 BAD code present"

cat > "${MODULE_DIR}/lib/facter/disk_usage.rb" <<'RUBY'
# frozen_string_literal: true

Facter.add(:disk_usage) do
  setcode do
    # GOOD: IO.popen declares subprocess intent; the array form avoids the shell.
    output = IO.popen(['df', '-h', '/'], &:read)
    output.split("\n").last.split[4]
  end
end
RUBY
assert_validate pass "issue #1 fixed"

# ===========================================================================
# Issue #2 -- Hash#inspect format reliance  (cop: HashInspect/LegacyHashInspectFormat)
#   Ruby 3.4+ renders hashes as {sym: val}, not {:sym=>val} (Ruby #20433).
# ===========================================================================
bold "ISSUE #2  Hash#inspect format reliance  ->  cop HashInspect/LegacyHashInspectFormat"

cat > "${MODULE_DIR}/spec/unit/disk_usage_spec.rb" <<'RUBY'
# frozen_string_literal: true

require 'spec_helper'

describe 'config rendering' do
  it 'renders the config' do
    # BAD: hardcoded legacy inspect format. Silently mismatches on Ruby 3.4+.
    content = '{:database=>"prod", :port=>5432}'
    expect(content).to include('{:database=>"prod", :port=>5432}')
  end
end
RUBY
assert_validate fail "issue #2 BAD code present"

cat > "${MODULE_DIR}/spec/unit/disk_usage_spec.rb" <<'RUBY'
# frozen_string_literal: true

require 'spec_helper'

describe 'config rendering' do
  it 'renders the config' do
    # GOOD: new Ruby 3.4+ inspect format. (Best practice is to avoid matching
    # inspect output at all -- compare structured data instead.)
    content = '{database: "prod", port: 5432}'
    expect(content).to include('{database: "prod", port: 5432}')
  end
end
RUBY
assert_validate pass "issue #2 fixed"

# ===========================================================================
# Issue #3 -- Bundled gem require failures   (NO cop exists yet)
#   Ruby 4 moves csv/logger/ostruct/benchmark/racc to bundled gems.
#   PDK does NOT catch this today -- detection is grep + runtime LoadError.
# ===========================================================================
bold "ISSUE #3  Bundled gem require failures  ->  NO cop (gap; grep only)"

cat > "${MODULE_DIR}/lib/facter/csv_fact.rb" <<'RUBY'
# frozen_string_literal: true

require 'csv'

Facter.add(:first_csv_field) do
  setcode do
    rows = CSV.read('/etc/my_app/config.csv')
    rows.first&.first
  end
end
RUBY

bold ">> Demonstrating the gap: validation PASSES even though 'csv' is undeclared"
assert_validate pass "issue #3 -- PDK does not flag the bare require"

bold ">> The detection the ticket recommends is grep (not pdk validate):"
( cd "${MODULE_DIR}" && grep -rn "require 'csv'\|require 'logger'\|require 'ostruct'\|require 'benchmark'\|require 'racc'" lib/ spec/ ) || true
echo
echo "Fix: declare the gem so it is present on Ruby 4. In the module Gemfile:"
echo "    gem 'csv', '~> 3.0'"
echo "(The Ruby code is unchanged; only the dependency declaration is added.)"
echo

rule
green "Demo complete. Issues #1 and #2 are caught by 'pdk validate ruby';"
green "issue #3 is a known gap (grep + runtime LoadError only)."
