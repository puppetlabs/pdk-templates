PR_DIR=$PWD

pdk new module pr_new_modules --template-url=$PR_DIR --skip-interview
pdk new module normal_module --skip-interview
cd normal_module
pdk convert --template-url=$PR_DIR --skip-interview --force
