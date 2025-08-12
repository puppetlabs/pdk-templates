# Testing PDK Module Gemfile Sources

## Description

This guide shows you how to manually test all gem source scenarios for PDK modules using the enhanced Gemfile template. These tests validate real gem installation behavior across different sources: rubygems.org, authenticated puppetcore, git repositories, and local file paths when developing or testing Puppet modules with PDK.

## Prerequisites

- **PDK Installed**: Latest version of PDK (Puppet Development Kit)
- **Puppet Forge Token**: Valid `PUPPET_FORGE_TOKEN` for authenticated scenarios
- **Network Access**: Ability to reach rubygems.org and internal Puppet sources  
- **Git Access**: SSH keys configured for private repository access
- **Clean Environment**: No conflicting environment variables

## Environment Setup

### Create a Test Module

Start by creating a new PDK module for testing:

```bash
# Create a test module
pdk new module test_module_sources --skip-interview
cd test_module_sources
```

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

### Scenario 1: Default Public RubyGems

Test basic functionality with public rubygems.org as the default source.

```bash
source ./clean_environment.sh
pdk bundle install
pdk bundle info puppet    # Expected: Latest public puppet version, e.g., 8.10.0 from rubygems.org
pdk bundle info facter    # Expected: Latest public facter version, e.g., 4.10.0 from rubygems.org

# Expected: gem source for puppet and facter is rubygems.org
cat Gemfile.lock | ruby -ne 'puts $_ if $_ =~ /remote:|^\s{4}(puppet|facter)\s\(/'
```

### Scenario 2: Default RubyGems with Specific Versions

Test version constraints with public rubygems.org.

```bash
source ./clean_environment.sh
export PUPPET_GEM_VERSION='~> 7.24.0'
export FACTER_GEM_VERSION='= 4.4.0'
pdk bundle install
pdk bundle info puppet    # Expected: 7.24.x from rubygems.org
pdk bundle info facter    # Expected: 4.4.0 from rubygems.org

# Expected: gem source for puppet and facter is rubygems.org
cat Gemfile.lock | ruby -ne 'puts $_ if $_ =~ /remote:|^\s{4}(puppet|facter)\s\(/'
```

### Scenario 3: Authenticated Puppetcore for puppet/facter

Test authenticated puppetcore access (requires valid PUPPET_FORGE_TOKEN).

```bash
source ./clean_environment.sh
source ./set_puppetcore_authentication.sh
export GEM_SOURCE_PUPPETCORE='https://rubygems-puppetcore.puppet.com'
pdk bundle install
pdk bundle info puppet    # Expected: Latest puppetcore version from authenticated source
pdk bundle info facter    # Expected: Latest puppetcore version from authenticated source

# Expected: rubygems-puppetcore.puppet.com is gem source for both puppet and facter
cat Gemfile.lock | ruby -ne 'puts $_ if $_ =~ /remote:|^\s{4}(puppet|facter)\s\(/'
```

### Scenario 4: Authenticated Puppetcore with Specific Versions

Test version pinning with authenticated puppetcore sources.

```bash
source ./clean_environment.sh
source ./set_puppetcore_authentication.sh
export GEM_SOURCE_PUPPETCORE='https://rubygems-puppetcore.puppet.com'
export PUPPET_GEM_VERSION='= 8.13.0'
export FACTER_GEM_VERSION='= 4.13.0'
pdk bundle install
pdk bundle info puppet    # Expected: 8.13.0 from puppetcore
pdk bundle info facter    # Expected: 4.13.0 from puppetcore

# Expected: rubygems-puppetcore.puppet.com is gem source for both puppet and facter
cat Gemfile.lock | ruby -ne 'puts $_ if $_ =~ /remote:|^\s{4}(puppet|facter)\s\(/'
```

### Scenario 5: Git Repository Sources

Test development workflow with git repositories that override the existing gem sources.

```bash
source ./clean_environment.sh
export PUPPET_GEM_VERSION='https://github.com/puppetlabs/puppet.git#main'
export FACTER_GEM_VERSION='https://github.com/puppetlabs/facter.git#main'
pdk bundle install
pdk bundle info puppet    # Expected: Git version (e.g., '8.x.x ab48604')
pdk bundle info facter    # Expected: Git version (e.g., '4.x.x 5554178')

# Expected: github repos are the gemsources for both puppet and facter
cat Gemfile.lock | ruby -ne 'puts $_ if $_ =~ /remote:|^\s{4}(puppet|facter)\s\(/'
```

### Scenario 6: Mixed Local and Remote Sources

Test facter from default source and puppet from local file path.

```bash
source ./clean_environment.sh

# Clone local puppet for testing
git clone https://github.com/puppetlabs/puppet.git tmp/puppet
export PUPPET_GEM_VERSION="file:///${PWD}/tmp/puppet"
pdk bundle install
pdk bundle info puppet    # Expected: Local file path
pdk bundle info facter    # Expected: Default source

# Expected: file path gemsource for puppet and default gemsource for facter
cat Gemfile.lock | ruby -ne 'puts $_ if $_ =~ /remote:|^\s{4}(puppet|facter)\s\(/'
```

### Scenario 7: Corporate Gem Source Override

Test using a corporate gem mirror for all gems.

```bash
source ./clean_environment.sh
export GEM_SOURCE='https://your-corporate-mirror.com/rubygems/'
pdk bundle install
pdk bundle info puppet    # Expected: Puppet from corporate mirror
pdk bundle info facter    # Expected: Facter from corporate mirror

# Expected: corporate mirror is gem source for all gems
cat Gemfile.lock | ruby -ne 'puts $_ if $_ =~ /remote:|^\s{4}(puppet|facter)\s\(/'
```

### Scenario 8: PDK Commands with Custom Sources

Test that PDK commands work correctly with custom gem sources.

```bash
source ./clean_environment.sh
export GEM_SOURCE_PUPPETCORE='https://rubygems-puppetcore.puppet.com'
source ./set_puppetcore_authentication.sh

# Test PDK functionality
pdk bundle install
pdk validate                    # Expected: Should work with custom puppet/facter
pdk test unit                   # Expected: Should work with custom puppet/facter
pdk new class example_class     # Expected: Should work with custom puppet/facter
```

### Finally do a clean reset

Return to default state.

```bash
source ./clean_environment.sh
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

| Scenario | Puppet Source | Facter Source | Other Gems | Notes |
|----------|---------------|---------------|------------|-------|
| 1 | rubygems.org | rubygems.org | rubygems.org | Default public gems |
| 2 | rubygems.org (specific) | rubygems.org (specific) | rubygems.org | Version constraints |
| 3 | rubygems-puppetcore.puppet.com | rubygems-puppetcore.puppet.com | rubygems.org | Requires auth |
| 4 | rubygems-puppetcore.puppet.com (specific) | rubygems-puppetcore.puppet.com (specific) | rubygems.org | Auth + versions |
| 5 | git repository | git repository | rubygems.org | Development workflow |
| 6 | local file path | rubygems.org | rubygems.org | Mixed sources |
| 7 | corporate mirror | corporate mirror | corporate mirror | Corporate environment |
| 8 | rubygems-puppetcore.puppet.com | rubygems-puppetcore.puppet.com | rubygems.org | PDK integration |

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
