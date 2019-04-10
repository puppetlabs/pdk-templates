#!/bin/bash
set -x # echo commands with vars expanded
set -e # exit immediately on error

TEMPLATE_PR_DIR=$PWD

# Make a new branch from the result of merging the PR commit into master
git branch travis_commit FETCH_HEAD

# Test if new module from PR commit is still functional.
pdk new module new_module --template-url="file://$TEMPLATE_PR_DIR" --template-ref=travis_commit --skip-interview
pushd new_module
grep template < metadata.json
cp "$TEMPLATE_PR_DIR/.travis/fixtures/new_provider_sync.yml" ./.sync.yml
pdk update --force
pdk new class new_module
pdk new defined_type testtype
pdk new provider testprovider
pdk new task testtask
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

# Create new module from master branch of official templates repo
pdk new module convert_from_master --template-url="https://github.com/puppetlabs/pdk-templates.git" --template-ref=master --skip-interview
pushd convert_from_master
grep template < metadata.json
# Attempt to convert to PR commit from official/master
pdk convert --template-url="file://$TEMPLATE_PR_DIR" --template-ref=travis_commit --skip-interview --force
cat convert_report.txt
popd
