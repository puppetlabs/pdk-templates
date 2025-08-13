# Testing PDK Module Gemfile Sources

## Description

This guide shows you how to manually test the `Gemfile` logic introduced by this PR <https://github.com/puppetlabs/pdk-templates/pull/621>.  These tests validate gem installation behavior by varying gemsources (public <https://rubygems.org>, private puppetcore <https://rubygems-puppetcore.puppet.com>, etc), and by replacing puppet/facter versions with git repositories, and local file paths.  Swapping in a file path reference to puppet, for example, is a good way develop and troubleshoot.

The scenarios focus on two areas:

- `pdk new module` - Can a new module swap in different gemsources and puppet/facter versions?
- `pdk update` - Will an existing module convert to the new Gemfile ok?

## Setup

Export a valid `PUPPET_FORGE_TOKEN` to enable access to puppetcore gems:

```bash
export PUPPET_FORGE_TOKEN=<VALID-LONG-TOKEN>
```

Create a local directory for testing:

```bash
# Create testing workspace
mkdir -p ~/pdk_gemfile_testing/{new_module_tests,update_module_tests}
cd ~/pdk_gemfile_testing
```

Export a valid `PUPPET_FORGE_TOKEN` to enable access to puppetcore gems:

```bash
export PUPPET_FORGE_TOKEN=<VALID-LONG-TOKEN>
```

Create reusable environment management scripts.  Each scenario can now be setup accurately and quickly.

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

## Testing Scenarios

### Verifying `pdk new module`

Create new modules using the enhanced Gemfile template to test initial setup scenarios.

#### Scenario 1: Default Public RubyGems (New Module)

Create a new module and test basic functionality with public rubygems.org.

```bash
cd ~/pdk_gemfile_testing
mkdir -p new_module_tests && cd new_module_tests
source ~/pdk_gemfile_testing/clean_environment.sh

# Create new module with enhanced template (local filesystem)
rm -rf ~/pdk_gemfile_testing/new_module_tests/test_default_gems 
pdk new module test_default_gems --skip-interview --template-url="${TEMPLATE_URL}"

# Alternative for Git repository:
# pdk new module test_default_gems --skip-interview \
#   --template-ref="${TEMPLATE_REF}" \
#   --template-branch="${TEMPLATE_BRANCH}"

cd test_default_gems

# Test gem installation and sources
bundle install
bundle info puppet    # Expected: Latest public puppet version, e.g., 8.10.0 from rubygems.org
bundle info facter    # Expected: Latest public facter version, e.g., 4.10.0 from rubygems.org

# Verify gem sources
cat Gemfile.lock | ruby -ne 'puts $_ if $_ =~ /remote:|^\s{4}(puppet|facter)\s\(/'

# Test PDK functionality
pdk validate
pdk new class example_class
pdk test unit
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

# Alternative for Git repository:
# pdk new module test_puppetcore_gems --skip-interview \
#   --template-ref="${TEMPLATE_REF}" \
#   --template-branch="${TEMPLATE_BRANCH}"

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

# Test PDK functionality
pdk validate
pdk new class puppetcore_class
pdk test unit
```

#### Scenario 3: Git Repository Sources (New Module)

Create a new module and test with git-based gem sources.

```bash
cd ~/pdk_gemfile_testing/new_module_tests
source ~/pdk_gemfile_testing/clean_environment.sh
export PUPPET_GEM_VERSION='https://github.com/puppetlabs/puppet-private.git#main'
export FACTER_GEM_VERSION='https://github.com/puppetlabs/facter-private.git#main'

# Create new module with enhanced template (local filesystem)
rm -rf test_git_gems
pdk new module test_git_gems --skip-interview --template-url="${TEMPLATE_URL}"

# Alternative for Git repository:
# pdk new module test_git_gems --skip-interview \
#   --template-ref="${TEMPLATE_REF}" \
#   --template-branch="${TEMPLATE_BRANCH}"

cd test_git_gems

# remove Gemfile and vendor because the pdk creates the module with a different lock file
rm -rf Gemfile.lock vendor

# Test gem installation from git sources
bundle install
bundle info puppet    # Expected: Git version (e.g., '8.x.x ab48604')
bundle info facter    # Expected: Git version (e.g., '4.x.x 5554178')

# Verify git sources
cat Gemfile.lock | ruby -ne 'puts $_ if $_ =~ /remote:|^\s{4}(puppet|facter)\s\(/'

# Test PDK functionality
pdk validate
pdk new class git_based_class
```

### Verifying `pdk update`

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
pdk update --template-ref=https://github.com/puppetlabs/pdk-templates --template-ref=cat_2416_fix_pdk_templates_gemfile  

export PUPPET_GEM_VERSION='https://github.com/puppetlabs/puppet-private.git#main'

# Test gem installation from git sources
rm -rf Gemfile.lock vendor
bundle install
bundle info puppet    # Expected: Git version (e.g., '8.x.x ab48604')
bundle info facter    # Expected: Git version (e.g., '4.x.x 5554178')

# Verify git sources
cat Gemfile.lock | ruby -ne 'puts $_ if $_ =~ /remote:|^\s{4}(puppet|facter)\s\(/'

# Test PDK functionality
pdk validate
pdk new class git_based_class
```

### Finally do a clean reset

Return to default state and clean up test modules.

```bash
cd ~/pdk_gemfile_testing
source ./clean_environment.sh

# Optional: Clean up test modules
# rm -rf new_module_tests update_module_tests
```

## Appendix

### Why can't PDK use your bundled environment?

PDK is designed as a self-contained tool with its own isolated Ruby and gem environment for consistency and reliability. In other words, the PDK has its own internal Puppet installation and doesn't automatically use the bundled Puppet version.  For example, when you run `pdk validate`, it will use PDK's internal Puppet version (e.g., 8.10.0) instead of your bundled version (e.g., 8.14.0 from puppetcore).

### Template Reference Setup

To test the enhanced Gemfile template, you have several options for referencing your template:

- **Local filesystem**: Use `--template-url="${TEMPLATE_URL}"`
- **Git repository**: Use `--template-ref="${TEMPLATE_REF}" --template-ref="${TEMPLATE_BRANCH}"`

#### Option 1: Local Filesystem Path (Recommended for Development) ⭐

PDK uses `--template-url` for local filesystem paths.  No branch parameter needed for local filesystem

```bash
# Use local filesystem path - much faster for iterative testing
export TEMPLATE_URL="/Users/gavin.didrichsen/@REFERENCES/github/app/development/tools/puppet/repositories/puppetlabs/pdk-templates"

# OR alternatively with "file://" (some PDK versions prefer this)
export TEMPLATE_URL="file:///Users/gavin.didrichsen/@REFERENCES/github/app/development/tools/puppet/repositories/puppetlabs/pdk-templates"

# create the new module
pdk new module test_puppetcore_gems --skip-interview --template-url="${TEMPLATE_URL}"
```

Although `pdk new module` works fine with the above, the `pdk update` does not.  It requires both  `--template-ref`.

#### Option 2: Git Repository Reference (Remote)

```bash
# Set template reference variables for your testing
export TEMPLATE_URL="https://github.com/puppetlabs/pdk-templates.git"
export TEMPLATE_REF="cat_2416_fix_pdk_templates_gemfile"  # Your feature branch

# Alternative: Use specific commit hash if needed
# export TEMPLATE_BRANCH="35f8fc1"  # Specific commit hash
```

#### PDK Command Differences
