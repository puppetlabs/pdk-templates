# Testing PDK Module Gemfile Sources

## Description

This guide explains how to vary the gemsources and gem versions in the Gemfile of your pdk module using the following environment variables:

| Environment Variable      | Purpose                                                                                   | Example Value                                                      |
|--------------------------|-------------------------------------------------------------------------------------------|--------------------------------------------------------------------|
| GEM_SOURCE               | Sets the default gem source for all gems.                                                 | https://rubygems.org<br>https://artifactory.delivery.puppetlabs.net/artifactory/api/gems/rubygems |
| GEM_SOURCE_PUPPETCORE    | Sets the gem source specifically for puppetcore gems (puppet, facter).                    | https://rubygems-puppetcore.puppet.com                             |
| PUPPET_GEM_VERSION       | Specifies the Puppet gem version, git repo, or local path to use.                         | 8.10.0<br>https://github.com/puppetlabs/puppet.git<br>/path/to/puppet |
| FACTER_GEM_VERSION       | Specifies the Facter gem version, git repo, or local path to use.                         | 4.0.52<br>https://github.com/puppetlabs/facter.git<br>/path/to/facter |
| DEBUG                    | Enables verbose Gemfile output for troubleshooting when set to a non-empty string.         | true     

This flexibility is essential for development workflows, allowing modules to be tested against different puppet and facter versions, whether sourced from public or private gem servers, local file paths, or git repositories.

## Setup

### Environment variables

- Export a valid `PUPPET_FORGE_TOKEN` to enable access to puppetcore gems:

  ```bash
  export PUPPET_FORGE_TOKEN=<VALID-LONG-TOKEN>
  ```

### Helper scripts

- Create a local directory for testing:

  ```bash
  # Create testing workspace
  mkdir -p ~/pdk_gemfile_testing/{new_module_tests,update_module_tests}
  cd ~/pdk_gemfile_testing
  ```

- Create reusable environment management scripts.  Each scenario can now be setup accurately and quickly.

  ```bash
  # Create environment cleanup script
  cat << 'EOF' > clean_environment.sh
  # Clean environment variables
  unset GEM_SOURCE GEM_SOURCE_PUPPETCORE
  unset PUPPET_GEM_VERSION FACTER_GEM_VERSION HIERA_GEM_VERSION  
  unset BUNDLE_RUBYGEMS___PUPPETCORE__PUPPET__COM
  # Clean bundler state
  rm -f Gemfile.lock && rm -rf vendor .bundle
  EOF
  chmod +x clean_environment.sh

  # Create puppetcore authentication script (if you have access)
  cat << 'EOF' > set_puppetcore_authentication.sh
  export BUNDLE_RUBYGEMS___PUPPETCORE__PUPPET__COM="forge-key:${PUPPET_FORGE_TOKEN}"
  EOF
  chmod +x set_puppetcore_authentication.sh
  ```

**Important**: Use `source ./script.sh` or `. ./script.sh` to execute these scripts otherwise the environment variables may not get registered on your terminal session.

## Scenarios

The following scenarios are categorised into two areas:

- `pdk new module` - Can a new module swap in different gemsources and puppet/facter versions?
- `pdk update` - Will an existing module convert to the new Gemfile ok?

### `pdk new module` scenarios

#### Scenario 1: Default Public RubyGems (New Module)

Create a new module and test basic functionality with public rubygems.org.

```bash
cd ~/pdk_gemfile_testing
mkdir -p new_module_tests && cd new_module_tests
source ~/pdk_gemfile_testing/clean_environment.sh

# Create new module with enhanced template (local filesystem)
rm -rf ~/pdk_gemfile_testing/new_module_tests/test_default_gems 
pdk new module test_default_gems --skip-interview --template-ref="${TEMPLATE_URL}"

cd ~/pdk_gemfile_testing/new_module_tests/test_default_gems

# Test gem installation and sources
bundle install
bundle info puppet    # Expected: Latest public puppet version, e.g., 8.10.0 from rubygems.org
bundle info facter    # Expected: Latest public facter version, e.g., 4.10.0 from rubygems.org

# Verify gem sources
cat Gemfile.lock | ruby -ne 'puts $_ if $_ =~ /remote:|^\s{4}(puppet|facter)\s\(/'
```

#### Scenario 2: Authenticated Puppetcore (New Module)

Create a new module and test with authenticated puppetcore sources.

```bash
# clean the environment before creating the module
source ~/pdk_gemfile_testing/clean_environment.sh

cd ~/pdk_gemfile_testing/new_module_tests

# Create new module with enhanced template (local filesystem)
rm -rf ~/pdk_gemfile_testing/new_module_tests/test_puppetcore_gems 
pdk new module test_puppetcore_gems --skip-interview --template-url="${TEMPLATE_URL}"

cd test_puppetcore_gems 

# clean again before bundle install and set authentication
source ~/pdk_gemfile_testing/clean_environment.sh
source ~/pdk_gemfile_testing/set_puppetcore_authentication.sh
export GEM_SOURCE_PUPPETCORE='https://rubygems-puppetcore.puppet.com'

# Test gem installation with puppetcore
bundle install
bundle info puppet    # Expected: Latest puppetcore version, e.g., 8.14.0
bundle info facter    # Expected: Latest puppetcore version, e.g., 4.14.0

# Verify puppetcore sources
cat Gemfile.lock | ruby -ne 'puts $_ if $_ =~ /remote:|^\s{4}(puppet|facter)\s\(/'
```

#### Scenario 3: Git Repository Sources (New Module)

Create a new module and test with git-based gem sources.

```bash
cd ~/pdk_gemfile_testing/new_module_tests
source ~/pdk_gemfile_testing/clean_environment.sh
export PUPPET_GEM_VERSION='https://github.com/puppetlabs/puppet-private.git#main'
export FACTER_GEM_VERSION='https://github.com/puppetlabs/facter-private.git#main'

# Create new module with enhanced template (local filesystem)
rm -rf ~/pdk_gemfile_testing/new_module_tests/test_git_gems
pdk new module test_git_gems --skip-interview --template-url="${TEMPLATE_URL}"

cd test_git_gems

# remove Gemfile and vendor because the pdk creates the module with a different lock file
rm -rf Gemfile.lock vendor

# Test gem installation from git sources
bundle install
bundle info puppet    # Expected: Git version (e.g., '8.x.x ab48604')
bundle info facter    # Expected: Git version (e.g., '4.x.x 5554178')

# Verify git sources
cat Gemfile.lock | ruby -ne 'puts $_ if $_ =~ /remote:|^\s{4}(puppet|facter)\s\(/'
```

### `pdk update` scenarios

Test updating existing modules to use the enhanced Gemfile template.

#### Scenario 4: Update Existing Module to Enhanced Template

Create a module with default template, then update to enhanced template.

```bash
cd ~/pdk_gemfile_testing
mkdir -p update_module_tests && cd update_module_tests
source ~/pdk_gemfile_testing/clean_environment.sh

# Create module with default PDK template first
# pdk new module test_update_module --skip-interview
git clone https://github.com/puppetlabs/puppetlabs-motd.git

cd puppetlabs-motd

# Update using --template-ref, e.g.,
pdk update --template-ref=https://github.com/puppetlabs/pdk-templates --template-ref=${TEMPLATE_REPO_BRANCH}  

export PUPPET_GEM_VERSION='https://github.com/puppetlabs/puppet-private.git#main'

# Test gem installation from git sources
rm -rf Gemfile.lock vendor
bundle install
bundle info puppet    # Expected: Git version (e.g., '8.x.x ab48604')
bundle info facter    # Expected: Git version (e.g., '4.x.x 5554178')

# Verify git sources
cat Gemfile.lock | ruby -ne 'puts $_ if $_ =~ /remote:|^\s{4}(puppet|facter)\s\(/'
```

### Clean up

Return to default state and clean up test modules.

```bash
cd ~/pdk_gemfile_testing
source ./clean_environment.sh

# Optional: Clean up test modules
# rm -rf ~/pdk_gemfile_testing
```

## Appendix

### Why can't PDK use your bundled environment?

PDK is designed as a self-contained tool with its own isolated Ruby and gem environment for consistency and reliability. In other words, the PDK has its own internal Puppet installation and doesn't automatically use the bundled Puppet version.  For example, when you run `pdk validate`, it will use PDK's internal Puppet version (e.g., 8.10.0) instead of your bundled version (e.g., 8.14.0 from puppetcore).
