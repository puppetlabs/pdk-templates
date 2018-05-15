
echo 'setup puppetlabs apt repo'
wget https://apt.puppetlabs.com/puppet5-release-trusty.deb
sudo dpkg -i puppet5-release-trusty.deb
sudo apt-get update

echo 'install pdk'
sudo apt-get install pdk

PR_DIR=$PWD

pdk new module pr_new_modules --template-url=$PR_DIR --skip-interview
pdk new module normal_module --skip-interview
cd normal_module
pdk convert --template-url=$PR_DIR --skip-interview --force
