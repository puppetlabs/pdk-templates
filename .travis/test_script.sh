#!/bin/bash
set -x # echo commands with vars expanded
set -e # exit immediately on error

TEMPLATE_PR_DIR=$PWD

# This tricks PDK into testing this commit instead of whatever master is on this repo
git update-ref refs/heads/master "$TRAVIS_COMMIT"

pdk new module new_module --template-url="file://$TEMPLATE_PR_DIR" --skip-interview
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

pdk new module convert_from_release_tag --skip-interview
pushd convert_from_release_tag
grep template < metadata.json
pdk convert --template-url="file://$TEMPLATE_PR_DIR" --skip-interview --force
cat convert_report.txt
popd

rm -f ~/.pdk/cache/answers.json

git clone --depth=1 --branch=master https://github.com/puppetlabs/pdk-templates.git ../master-pdk-templates
pdk new module convert_from_master --template-url="file://$TEMPLATE_PR_DIR/../master-pdk-templates" --skip-interview
pushd convert_from_master
grep template < metadata.json
pdk convert --template-url="file://$TEMPLATE_PR_DIR" --skip-interview --force
cat convert_report.txt
popd
