#!/bin/bash
set -x # echo commands with vars expanded
set -e # exit immediately on error

TEMPLATE_PR_DIR=$PWD

# Make a branch from checked out HEAD so that we can target
# it specifically with --template-ref
git checkout -b travis_commit

# Test if new module from PR commit is still functional.
pdk new module new_module --template-url="file://$TEMPLATE_PR_DIR" --template-ref=travis_commit --skip-interview
pushd new_module
grep template < metadata.json
cp "$TEMPLATE_PR_DIR/.travis/fixtures/new_provider_sync.yml" ./.sync.yml
pdk update --force
pdk new class new_module
pdk new defined_type testtype
pdk new fact testfact || true # not available in pdk 1.18 yet
pdk new function --type native testfunc_nat || true # not available in pdk 1.18 yet
pdk new function --type v4 testfunc_v4 || true # not available in pdk 1.18 yet
pdk new provider testprovider
pdk new task testtask
pdk new transport testtransport
pdk validate
pdk test unit
popd

rm -f ~/.pdk/cache/answers.json

# Create new module from default template-url and release tag
pdk new module convert_from_release_tag --skip-interview
pushd convert_from_release_tag
grep template < metadata.json
# Attempt to convert to PR commit from release tag
pdk convert --template-url="file://$TEMPLATE_PR_DIR" --template-ref=travis_commit --skip-interview --force
cat convert_report.txt
popd

rm -f ~/.pdk/cache/answers.json

# Create new module from main branch of official templates repo
pdk new module convert_from_main --template-url="https://github.com/puppetlabs/pdk-templates.git" --template-ref=main --skip-interview
pushd convert_from_main
grep template < metadata.json
# Attempt to convert to PR commit from official/main
pdk convert --template-url="file://$TEMPLATE_PR_DIR" --template-ref=travis_commit --skip-interview --force
cat convert_report.txt
popd
