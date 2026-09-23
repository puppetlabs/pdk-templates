#!/bin/bash
set -x # echo commands with vars expanded
set -e # exit immediately on error

TEMPLATE_PR_DIR=$PWD

# Make a branch from checked out HEAD so that we can target
# it specifically with --template-ref
git checkout -b ci_commit

# Test if new module from PR commit is still functional.
pdk new module new_module --template-url="file://$TEMPLATE_PR_DIR" --template-ref=ci_commit --skip-interview
pushd new_module
grep template < metadata.json
[ ! -f .github/workflows/ci.yml ] # ci.yml is unmanaged: true by default, so PDK skips rendering it entirely -- byte-identical to pre-acceptance_flags behavior (TEST-02a)
[ ! -f .github/workflows/nightly.yml ] # nightly.yml is unmanaged: true by default, so PDK skips rendering it entirely -- byte-identical to pre-acceptance_flags behavior (TEST-02a, D-13)
cp "$TEMPLATE_PR_DIR/.ci/fixtures/new_provider_sync.yml" ./.sync.yml
grep -q "NewCops: enable" ./.rubocop.yml # Ensure the slim template is applied (NewCops governs cops, not per-cop enumeration)
grep -A 5 "Style/TrailingCommaInHashLiteral" ./.rubocop.yml | grep -q "EnforcedStyleForMultiline: comma" # Ensure the profile merge actually contributed a profile-sourced tuning, not just the hardcoded NewCops key
pdk update --force
grep -A 1 "Performance/CaseWhenSplat" ./.rubocop.yml | grep -q "false" # Ensure the cop_overrides override is rendered after update
cp .sync.yml .sync.yml.orig
cat > .sync.yml <<'YAML'
---
.rubocop.yml:
  cop_overrides:
    Style/TrailingCommaInHashLiteral: '---'
YAML
pdk update --force
[ -z "$(grep "Style/TrailingCommaInHashLiteral" ./.rubocop.yml)" ] # Ensure a cop_overrides knockout ('---') drops the cop entirely rather than rendering the empty string PDK's outer .sync.yml merge leaves behind
mv .sync.yml.orig .sync.yml
pdk update --force
cp .sync.yml .sync.yml.orig
cat > .sync.yml <<'YAML'
---
.rubocop.yml:
  selected_profile: off
YAML
pdk update --force
grep -q "DisabledByDefault: true" ./.rubocop.yml # Ensure selected_profile: 'off' (YAML-coerced to boolean false) renders RuboCop's native disable-all switch, exercising the boolean-coercion guard. DisabledByDefault is a new AllCops key so deep_merge appends it after the Exclude array -- check the whole file, not a fixed window after AllCops.
grep -q "NewCops: disable" ./.rubocop.yml
mv .sync.yml.orig .sync.yml
pdk update --force
grep -qF 'flags: "--platform-exclude centos-7 --platform-exclude oraclelinux-7 --message \"hello\""' .github/workflows/ci.yml # Ensure acceptance_flags override + knockout + repeated-flag-name (CR-01 regression) + adversarial quote render on ci.yml (TEST-01, TEST-02b)
grep -qF 'flags: "--platform-exclude centos-7 --platform-exclude oraclelinux-7 --message \"hello\""' .github/workflows/nightly.yml # Ensure acceptance_flags override + knockout + repeated-flag-name (CR-01 regression) + adversarial quote render on nightly.yml independently (TEST-01, TEST-02b, D-13)
pdk new class new_module
pdk new defined_type test_type
pdk new fact test_fact || true # not available in pdk 1.18 yet
pdk new function --type native testfunc_nat || true # not available in pdk 1.18 yet
pdk new function --type v4 testfunc_v4 || true # not available in pdk 1.18 yet
pdk new provider test_provider
pdk new task test_task
pdk new transport test_transport

# Check the resolved (not rendered) gemsource_puppetcore via Bundler::Dsl, the same approach
# pdk-private uses to decide whether to trust the vendored lock. eval_gemfile runs the Gemfile's
# literal Ruby, so the credential warning may print to stderr below -- expected; checks only read stdout.

# puppetcore is the default with no credentials present
[ "$(env -u PUPPET_FORGE_TOKEN -u BUNDLE_RUBYGEMS___PUPPETCORE__PUPPET__COM ruby -rbundler -e '
  dsl = Bundler::Dsl.new
  dsl.eval_gemfile("Gemfile")
  %w[puppet facter bolt].each { |n| puts dsl.dependencies.find { |d| d.name == n }&.source&.remotes&.first }
' 2>/dev/null | grep -cF 'rubygems-puppetcore.puppet.com')" = 3 ]

# token presence doesn't change resolution
[ "$(PUPPET_FORGE_TOKEN=fake-token-value ruby -rbundler -e '
  dsl = Bundler::Dsl.new
  dsl.eval_gemfile("Gemfile")
  %w[puppet facter bolt].each { |n| puts dsl.dependencies.find { |d| d.name == n }&.source&.remotes&.first }
' 2>/dev/null | grep -cF 'rubygems-puppetcore.puppet.com')" = 3 ]

# downstream gem-version gating picks the puppetcore branch
[ "$(ruby -rbundler -e '
  dsl = Bundler::Dsl.new
  dsl.eval_gemfile("Gemfile")
  puts dsl.dependencies.find { |d| d.name == "voxpupuli-puppet-lint-plugins" }.requirement.to_s
' 2>/dev/null)" = '~> 7.0' ]
[ "$(ruby -rbundler -e '
  dsl = Bundler::Dsl.new
  dsl.eval_gemfile("Gemfile")
  puts dsl.dependencies.find { |d| d.name == "puppetlabs_spec_helper" }.requirement.to_s
' 2>/dev/null)" = '~> 9.0' ]

# persisted gemsource.public opt-out routes to public rubygems.org; re-checked from a separate
# process to prove persistence
ruby -rbundler -e 'Bundler.settings.set_local("gemsource.public", "true")'
[ "$(ruby -rbundler -e '
  dsl = Bundler::Dsl.new
  dsl.eval_gemfile("Gemfile")
  puts dsl.dependencies.find { |d| d.name == "puppet" }&.source&.remotes&.first
' 2>/dev/null | grep -cF 'rubygems.org')" = 1 ]
[ "$(ruby -rbundler -e '
  dsl = Bundler::Dsl.new
  dsl.eval_gemfile("Gemfile")
  puts dsl.dependencies.find { |d| d.name == "puppet" }&.source&.remotes&.first
' 2>/dev/null | grep -cF 'puppetcore')" = 0 ]

# downstream gem-version gating picks the public branch under the opt-out
[ "$(ruby -rbundler -e '
  dsl = Bundler::Dsl.new
  dsl.eval_gemfile("Gemfile")
  puts dsl.dependencies.find { |d| d.name == "voxpupuli-puppet-lint-plugins" }.requirement.to_s
' 2>/dev/null)" = '~> 6.0' ]
[ "$(ruby -rbundler -e '
  dsl = Bundler::Dsl.new
  dsl.eval_gemfile("Gemfile")
  puts dsl.dependencies.find { |d| d.name == "puppetlabs_spec_helper" }.requirement.to_s
' 2>/dev/null)" = '~> 8.0' ]

# restore for the pdk bundle install / validate / test unit block below
ruby -rbundler -e 'Bundler.settings.set_local("gemsource.public", nil)'
[ "$(ruby -rbundler -e '
  dsl = Bundler::Dsl.new
  dsl.eval_gemfile("Gemfile")
  puts dsl.dependencies.find { |d| d.name == "puppet" }&.source&.remotes&.first
' 2>/dev/null | grep -cF 'rubygems-puppetcore.puppet.com')" = 1 ]

# ensure_bundle! skips actual `bundle install` for packaged PDK installs; pdk bundle install does not.
pdk bundle install
pdk validate
pdk test unit
popd

rm -f ~/.pdk/cache/answers.json

# Create new module from default template-url and release tag
pdk new module convert_from_release_tag --skip-interview
pushd convert_from_release_tag
grep template < metadata.json
# Attempt to convert to PR commit from release tag
pdk convert --template-url="file://$TEMPLATE_PR_DIR" --template-ref=ci_commit --skip-interview --force
cat convert_report.txt
popd

rm -f ~/.pdk/cache/answers.json

# Create new module from main branch of official templates repo
pdk new module convert_from_main --template-url="https://github.com/puppetlabs/pdk-templates.git" --template-ref=main --skip-interview
pushd convert_from_main
grep template < metadata.json
# Attempt to convert to PR commit from official/main
pdk convert --template-url="file://$TEMPLATE_PR_DIR" --template-ref=ci_commit --skip-interview --force
cat convert_report.txt
popd
