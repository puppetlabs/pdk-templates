# Testing PDK Module Gemfile Sources

## Description

This guide shows you how to manually test all gem source scenarios for PDK modules using the enhanced Gemfile template. These tests validate real gem installation behavior across different sources: rubygems.org, authenticated puppetcore, git repositories, and local file paths when developing or testing Puppet modules with PDK.

**Key Testing Areas:**

- `pdk new module` - Creating new modules with enhanced Gemfile template
- `pdk update` - Updating existing modules to use enhanced Gemfile template  
- Various gem source configurations and combinations

## Prerequisites

- **PDK Installed**: Latest version of PDK (Puppet Development Kit)
- **Puppet Forge Token**: Valid `PUPPET_FORGE_TOKEN` for authenticated scenarios
- **Network Access**: Ability to reach rubygems.org and internal Puppet sources  
- **Git Access**: SSH keys configured for private repository access
- **Clean Environment**: No conflicting environment variables

## Environment Setup

### Testing Directory Structure

Create a dedicated testing directory structure:

```bash
# Create testing workspace
mkdir -p ~/pdk_gemfile_testing
cd ~/pdk_gemfile_testing

# We'll create modules here:
# - new_module_tests/     (for pdk new module testing)
# - update_module_tests/  (for pdk update testing) 
```

### Template Reference Setup

To test the enhanced Gemfile template, you have several options for referencing your template:

#### Option 1: Local Filesystem Path (Recommended for Development) ⭐

```bash
# Use local filesystem path - much faster for iterative testing
export TEMPLATE_URL="/Users/gavin.didrichsen/@REFERENCES/github/app/development/tools/puppet/repositories/puppetlabs/pdk-templates"

# PDK uses --template-url for local filesystem paths
# No branch parameter needed for local filesystem
```

#### Option 2: Git Repository Reference (Remote)

```bash
# Set template reference variables for your testing
export TEMPLATE_REF="https://github.com/puppetlabs/pdk-templates.git"
export TEMPLATE_BRANCH="cat_2416_fix_pdk_templates_gemfile"  # Your feature branch

# Alternative: Use specific commit hash if needed
# export TEMPLATE_BRANCH="35f8fc1"  # Specific commit hash
```

#### Option 3: File URL Format

```bash
# Alternative file URL format (some PDK versions prefer this)
export TEMPLATE_URL="file:///Users/gavin.didrichsen/@REFERENCES/github/app/development/tools/puppet/repositories/puppetlabs/pdk-templates"
```

**Recommendation**: Use Option 1 (local filesystem path) for development and testing as it's much faster and doesn't require network access or git operations.

#### PDK Command Differences

- **Local filesystem**: Use `--template-url="${TEMPLATE_URL}"`
- **Git repository**: Use `--template-ref="${TEMPLATE_REF}" --template-branch="${TEMPLATE_BRANCH}"`

#### Advantages of Local Filesystem Path

- **Speed**: No network latency or git operations
- **Real-time testing**: Test changes immediately without committing/pushing
- **Offline development**: Works without internet connection
- **Debugging**: Easy to modify template and retest quickly
- **Iteration**: Perfect for development workflow

#### When to Use Each Option

- **Local Filesystem**: Development, testing, debugging template changes
- **Git Repository**: CI/CD, sharing with team, production testing
- **File URL**: Alternative to filesystem path, some PDK versions prefer this format

### Create Helper Scripts

Before running any scenarios, make sure to export `PUPPET_FORGE_TOKEN` with a valid token if you have access to puppetcore:

```bash
export PUPPET_FORGE_TOKEN=<VALID-LONG-TOKEN>
```

Then create reusable environment management scripts:

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

**Important**: Use `source ./script.sh` or `. ./script.sh` to execute these scripts.

## Testing Scenarios

### Phase 1: PDK New Module Testing

Create new modules using the enhanced Gemfile template to test initial setup scenarios.

#### Scenario 1: Default Public RubyGems (New Module)

Create a new module and test basic functionality with public rubygems.org.

```bash
cd ~/pdk_gemfile_testing
mkdir -p new_module_tests && cd new_module_tests
source ../clean_environment.sh

# Create new module with enhanced template (local filesystem)
pdk new module test_default_gems --skip-interview --template-url="${TEMPLATE_URL}"

# Alternative for Git repository:
# pdk new module test_default_gems --skip-interview \
#   --template-ref="${TEMPLATE_REF}" \
#   --template-branch="${TEMPLATE_BRANCH}"

cd test_default_gems

# Test gem installation and sources
pdk bundle install
pdk bundle info puppet    # Expected: Latest public puppet version, e.g., 8.10.0 from rubygems.org
pdk bundle info facter    # Expected: Latest public facter version, e.g., 4.10.0 from rubygems.org

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
cd ~/pdk_gemfile_testing/new_module_tests
source ../clean_environment.sh
source ../set_puppetcore_authentication.sh
export GEM_SOURCE_PUPPETCORE='https://rubygems-puppetcore.puppet.com'

# Create new module with enhanced template (local filesystem)
pdk new module test_puppetcore_gems --skip-interview \
  --template-url="${TEMPLATE_URL}"

# Alternative for Git repository:
# pdk new module test_puppetcore_gems --skip-interview \
#   --template-ref="${TEMPLATE_REF}" \
#   --template-branch="${TEMPLATE_BRANCH}"

cd test_puppetcore_gems

# Test gem installation with puppetcore
pdk bundle install
pdk bundle info puppet    # Expected: Latest puppetcore version
pdk bundle info facter    # Expected: Latest puppetcore version

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
source ../clean_environment.sh
export PUPPET_GEM_VERSION='https://github.com/puppetlabs/puppet.git#main'
export FACTER_GEM_VERSION='https://github.com/puppetlabs/facter.git#main'

# Create new module with enhanced template (local filesystem)
pdk new module test_git_gems --skip-interview \
  --template-url="${TEMPLATE_URL}"

# Alternative for Git repository:
# pdk new module test_git_gems --skip-interview \
#   --template-ref="${TEMPLATE_REF}" \
#   --template-branch="${TEMPLATE_BRANCH}"

cd test_git_gems

# Test gem installation from git sources
pdk bundle install
pdk bundle info puppet    # Expected: Git version (e.g., '8.x.x ab48604')
pdk bundle info facter    # Expected: Git version (e.g., '4.x.x 5554178')

# Verify git sources
cat Gemfile.lock | ruby -ne 'puts $_ if $_ =~ /remote:|^\s{4}(puppet|facter)\s\(/'

# Test PDK functionality
pdk validate
pdk new class git_based_class
```

### Phase 2: PDK Update Testing

Test updating existing modules to use the enhanced Gemfile template.

#### Scenario 4: Update Existing Module to Enhanced Template

Create a module with default template, then update to enhanced template.

```bash
cd ~/pdk_gemfile_testing
mkdir -p update_module_tests && cd update_module_tests
source ../clean_environment.sh

# Create module with default PDK template first
pdk new module test_update_module --skip-interview

cd test_update_module

# Check initial Gemfile (should be standard template)
echo "=== Initial Gemfile content ==="
cat Gemfile

# Update to enhanced template (local filesystem)
pdk update --template-url="${TEMPLATE_URL}"

# Alternative for Git repository:
# pdk update --template-ref="${TEMPLATE_REF}" --template-branch="${TEMPLATE_BRANCH}"

# Check updated Gemfile (should now have enhanced features)
echo "=== Updated Gemfile content ==="
cat Gemfile

# Test functionality with enhanced template
pdk bundle install
pdk validate
pdk test unit
```

#### Scenario 5: Update with Custom Gem Sources

Update existing module and test with custom gem sources.

```bash
cd ~/pdk_gemfile_testing/update_module_tests
source ../clean_environment.sh
source ../set_puppetcore_authentication.sh
export GEM_SOURCE_PUPPETCORE='https://rubygems-puppetcore.puppet.com'

# Create standard module
pdk new module test_update_with_sources --skip-interview
cd test_update_with_sources

# Update to enhanced template (local filesystem)
pdk update --template-url="${TEMPLATE_URL}"

# Alternative for Git repository:
# pdk update --template-ref="${TEMPLATE_REF}" --template-branch="${TEMPLATE_BRANCH}"

# Test with custom sources
pdk bundle install
pdk bundle info puppet    # Expected: puppetcore version
pdk bundle info facter    # Expected: puppetcore version

# Verify sources
cat Gemfile.lock | ruby -ne 'puts $_ if $_ =~ /remote:|^\s{4}(puppet|facter)\s\(/'
```

### Phase 3: Legacy Scenarios (Backwards Compatibility)

#### Scenario 6: Version-Specific Testing

Test version constraints work correctly with enhanced template.

```bash
cd ~/pdk_gemfile_testing/new_module_tests
source ../clean_environment.sh
export PUPPET_GEM_VERSION='~> 7.24.0'
export FACTER_GEM_VERSION='= 4.4.0'

pdk new module test_version_constraints --skip-interview \
  --template-url="${TEMPLATE_URL}"

# Alternative for Git repository:
# pdk new module test_version_constraints --skip-interview \
#   --template-ref="${TEMPLATE_REF}" \
#   --template-branch="${TEMPLATE_BRANCH}"

cd test_version_constraints

pdk bundle install
pdk bundle info puppet    # Expected: 7.24.x from rubygems.org
pdk bundle info facter    # Expected: 4.4.0 from rubygems.org

# Verify version constraints work
cat Gemfile.lock | ruby -ne 'puts $_ if $_ =~ /remote:|^\s{4}(puppet|facter)\s\(/'
```

#### Scenario 7: Mixed Local and Remote Sources

Test combination of local file paths and remote sources.

```bash
cd ~/pdk_gemfile_testing/new_module_tests
source ../clean_environment.sh

# Clone local puppet for testing
git clone https://github.com/puppetlabs/puppet.git tmp/puppet
export PUPPET_GEM_VERSION="file:///${PWD}/tmp/puppet"

pdk new module test_mixed_sources --skip-interview \
  --template-url="${TEMPLATE_URL}"

# Alternative for Git repository:
# pdk new module test_mixed_sources --skip-interview \
#   --template-ref="${TEMPLATE_REF}" \
#   --template-branch="${TEMPLATE_BRANCH}"

cd test_mixed_sources

pdk bundle install
pdk bundle info puppet    # Expected: Local file path
pdk bundle info facter    # Expected: Default source

# Verify mixed sources
cat Gemfile.lock | ruby -ne 'puts $_ if $_ =~ /remote:|^\s{4}(puppet|facter)\s\(/'
```

#### Scenario 8: Corporate Gem Source Override

Test using a corporate gem mirror for all gems.

```bash
cd ~/pdk_gemfile_testing/new_module_tests
source ../clean_environment.sh
export GEM_SOURCE='https://your-corporate-mirror.com/rubygems/'

pdk new module test_corporate_mirror --skip-interview \
  --template-url="${TEMPLATE_URL}"

# Alternative for Git repository:
# pdk new module test_corporate_mirror --skip-interview \
#   --template-ref="${TEMPLATE_REF}" \
#   --template-branch="${TEMPLATE_BRANCH}"

cd test_corporate_mirror

pdk bundle install
pdk bundle info puppet    # Expected: Puppet from corporate mirror
pdk bundle info facter    # Expected: Facter from corporate mirror

# Verify corporate mirror usage
cat Gemfile.lock | ruby -ne 'puts $_ if $_ =~ /remote:|^\s{4}(puppet|facter)\s\(/'
```

### Finally do a clean reset

Return to default state and clean up test modules.

```bash
cd ~/pdk_gemfile_testing
source ./clean_environment.sh

# Optional: Clean up test modules
# rm -rf new_module_tests update_module_tests
```

## Template Testing Workflows

### Quick Template Verification

To quickly verify the enhanced template is working:

```bash
# Check if enhanced features are present in generated Gemfile
cd ~/pdk_gemfile_testing
pdk new module quick_test --skip-interview \
  --template-url="${TEMPLATE_URL}"

# Alternative for Git repository:
# pdk new module quick_test --skip-interview \
#   --template-ref="${TEMPLATE_REF}" \
#   --template-branch="${TEMPLATE_BRANCH}"

cd quick_test

# Look for enhanced features in Gemfile
grep -n "gemsource_" Gemfile  # Should show gemsource_default and gemsource_puppetcore
grep -n "location_for.*opts" Gemfile  # Should show enhanced location_for function
grep -n "DEBUG_GEMS\|VERBOSE" Gemfile  # Should show debug functionality
```

### Template Comparison Testing

Compare old vs new template behavior:

```bash
cd ~/pdk_gemfile_testing

# Create module with default template
pdk new module compare_default --skip-interview
# Create module with enhanced template (local filesystem)
pdk new module compare_enhanced --skip-interview \
  --template-url="${TEMPLATE_URL}"

# Alternative for Git repository:
# pdk new module compare_enhanced --skip-interview \
#   --template-ref="${TEMPLATE_REF}" \
#   --template-branch="${TEMPLATE_BRANCH}"

# Compare Gemfiles
echo "=== Default Template Gemfile ==="
head -20 compare_default/Gemfile

echo "=== Enhanced Template Gemfile ==="
head -20 compare_enhanced/Gemfile

# Test both with same environment
cd compare_default && pdk bundle install && cd ..
cd compare_enhanced && pdk bundle install && cd ..

# Compare bundle info
echo "=== Default Template Bundle Info ==="
cd compare_default && pdk bundle info puppet facter && cd ..

echo "=== Enhanced Template Bundle Info ==="
cd compare_enhanced && pdk bundle info puppet facter && cd ..
```

## Module Development Workflow Testing

### Testing with RSpec

Test that RSpec works with different gem sources:

```bash
source ./clean_environment.sh
export GEM_SOURCE_PUPPETCORE='https://rubygems-puppetcore.puppet.com'
source ./set_puppetcore_authentication.sh

pdk bundle install
pdk new class example_class
pdk test unit --verbose
```

### Testing with Different Puppet Versions

Test module compatibility across Puppet versions:

```bash
# Test with Puppet 7.x
source ./clean_environment.sh
export PUPPET_GEM_VERSION='~> 7.24.0'
pdk bundle install
pdk validate

# Test with Puppet 8.x
source ./clean_environment.sh
export PUPPET_GEM_VERSION='~> 8.10.0'
pdk bundle install
pdk validate
```

## Debugging

### Enable Debug Output

```bash
DEBUG_GEMS=1 pdk bundle install
# OR
VERBOSE=1 pdk bundle install
```

This shows exactly which gem statements are generated by the enhanced Gemfile template.

### Common Issues

1. **Authentication failures**: Ensure `PUPPET_FORGE_TOKEN` is valid and `BUNDLE_RUBYGEMS___PUPPETCORE__PUPPET__COM` is set correctly
2. **Network timeouts**: Check corporate firewall settings for rubygems.org access
3. **Git access**: Verify SSH keys for private repositories
4. **Version conflicts**: Use `pdk bundle exec gem dependency puppet` to check constraints
5. **PDK cache issues**: Clear PDK cache with `rm -rf ~/.pdk/cache`

### Inspecting Generated Gemfile

To see what the actual Gemfile looks like after PDK processes the template:

```bash
cat Gemfile
```

## Expected Results Summary

| Scenario | Test Type | Puppet Source | Facter Source | Other Gems | Template Ref |
|----------|-----------|---------------|---------------|------------|--------------|
| 1 | New Module | rubygems.org | rubygems.org | rubygems.org | Enhanced |
| 2 | New Module | rubygems-puppetcore.puppet.com | rubygems-puppetcore.puppet.com | rubygems.org | Enhanced |
| 3 | New Module | git repository | git repository | rubygems.org | Enhanced |
| 4 | Update | rubygems.org | rubygems.org | rubygems.org | Default→Enhanced |
| 5 | Update | rubygems-puppetcore.puppet.com | rubygems-puppetcore.puppet.com | rubygems.org | Default→Enhanced |
| 6 | New Module | rubygems.org (7.24.x) | rubygems.org (4.4.0) | rubygems.org | Enhanced |
| 7 | New Module | local file path | rubygems.org | rubygems.org | Enhanced |
| 8 | New Module | corporate mirror | corporate mirror | corporate mirror | Enhanced |

## Template-Specific Testing Best Practices

1. **Always specify template reference**: Use `--template-ref` and `--template-branch` for consistent testing
2. **Test both new and update workflows**: Ensure enhanced template works in both scenarios
3. **Verify template features**: Check generated Gemfile contains enhanced functions
4. **Compare with default**: Test side-by-side with default template to verify improvements
5. **Test environment isolation**: Use clean environments between tests
6. **Document template versions**: Keep track of which template version/branch you're testing

## Troubleshooting Template Issues

### Template Not Found

```bash
# Verify template reference is correct
git ls-remote "${TEMPLATE_REF}" "${TEMPLATE_BRANCH}"

# Check PDK template cache
pdk config get template_cache_dir
# Clear cache if needed
rm -rf $(pdk config get template_cache_dir)
```

### Template Not Applied

```bash
# Force template update (local filesystem)
pdk update --force --template-url="${TEMPLATE_URL}"

# Alternative for Git repository:
# pdk update --force --template-ref="${TEMPLATE_REF}" --template-branch="${TEMPLATE_BRANCH}"

# Verify Gemfile content
grep -n "# For puppetcore" Gemfile  # Should be present in enhanced template
```

## Module Testing Best Practices

1. **Always test with clean environment**: Use the cleanup script between scenarios
2. **Test PDK commands**: Ensure `pdk validate`, `pdk test unit`, and `pdk new` work correctly
3. **Verify gem sources**: Always check `Gemfile.lock` to confirm expected sources
4. **Test different Puppet versions**: Ensure your module works across supported versions
5. **Check for conflicts**: Look for gem version conflicts in different scenarios

## Related Documentation

- [PDK Documentation](https://puppet.com/docs/pdk/latest/pdk.html) - Official PDK documentation
- [Enhanced Gemfile Template](../moduleroot/Gemfile.erb) - The actual enhanced Gemfile template
- [Puppet Module Development](https://puppet.com/docs/puppet/latest/modules_fundamentals.html) - Module development guide
