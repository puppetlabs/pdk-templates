PR_DIR=$PWD

pdk new module pr_new_modules --template-url=$PR_DIR --skip-interview

pdk new module normal_module --skip-interview
cd normal_module
pdk convert --template-url=$PR_DIR --skip-interview --force
cat convert_report.txt

cd $PR_DIR
git clone --depth=1 --branch=master https://github.com/puppetlabs/pdk-templates.git ../master-pdk-templates
pdk new module pr_diff --template-url=$PR_DIR/../master-pdk-templates --skip-interview
cd pr_diff
pdk convert --template-url=$PR_DIR --skip-interview --force
cat convert_report.txt
