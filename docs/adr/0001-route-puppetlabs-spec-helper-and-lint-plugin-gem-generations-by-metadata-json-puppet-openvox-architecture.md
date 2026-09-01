---
tags:
  - -jira/bolt/193/bolt-migrate-to-puppet9/inbox
  - -scope/implementation
---

# 0001. Route puppetlabs_spec_helper and lint-plugin gem generations by metadata.json puppet/openvox architecture

Date: 2026-09-01

## Status

Accepted

## Context

Recently the `puppetlabs_spec_helper` `~> 9.0` dropped its dependency on Vox Pupuli's `puppet-syntax` gem in favour of puppet's own `puppetlabs-syntax` gem.  This fork was necessary because newer versions of the `puppet-syntax` gemspec enforced the `openvox` instead of the `puppet` architecture.  As a result, the pdk-templates pinned `puppetlabs_spec_helper` to a single wide range (`>= 8.0, < 10.0`) in the `config_defaults.yml` allowing modules to 'straddle' either architecture (`puppet` or `openvox`).  **The problem was that** there was no way to enforce the correct gem set for a particular architecture.  `puppet` modules, for example, always required the `~> 9.0` `puppetlabs_spec_helper` while `openvox` the `~> 8.0`.

Since every PDK command that manages bundling (`pdk validate`, `pdk test unit`, `pdk convert`, `pdk update`, `pdk console`, `pdk release`) calls `PDK::Util::Bundler.ensure_bundle!`, which runs real Bundler against `bundle.gemfile` at `Dir.pwd`; then the solution must place the routing logic in the rendered `Gemfile`.

## Decision

`pdk-templates` now decides which generation of ecosystem-split gems a module resolves to based on the module's own `metadata.json`, evaluated live by Bundler on every `bundle install`/`bundle exec` — not decided by PDK's CLI, and not left to whatever Bundler happens to already have locked.

A `puppet_module?` helper is defined identically in both `moduleroot/Gemfile.erb` and `moduleroot/Rakefile.erb` (each file is rendered and evaluated independently, so the helper can't be shared across them without introducing a shared library — not justified for an ~8-line predicate):

```ruby
# A module targets the Puppet, Inc. architecture (puppetlabs-syntax, puppetlabs_spec_helper
# 9.x, and so on) by default. It only opts into the OpenVox architecture -- and the older
# gem generation that goes with it -- by explicitly declaring an "openvox" requirement in
# its own metadata.json. No requirement, or an explicit "puppet" requirement, both mean
# "puppet" architecture.
def puppet_module?
  return true unless File.file?('metadata.json')

  require 'json'
  metadata = JSON.parse(File.read('metadata.json'))
  Array(metadata['requirements']).none? { |r| r['name'] == 'openvox' }
rescue JSON::ParserError
  true
end
```
(local to this session's working tree at time of writing — pending commit/push, no permalink yet)

Every architecture-dependent gem is collected under one new `Gemfile.architecture_gems` key in `config_defaults.yml`, nested by architecture then by Bundler group:

```yaml
architecture_gems:
  puppet:
    ':development':
      - gem: 'voxpupuli-puppet-lint-plugins'
        version: '~> 7.0'
    ':development, :release_prep':
      - gem: 'puppetlabs_spec_helper'
        version: '~> 9.0'
  openvox:
    ':development':
      - gem: 'voxpupuli-puppet-lint-plugins'
        version: '~> 6.0'
    ':development, :release_prep':
      - gem: 'puppetlabs_spec_helper'
        version: '~> 8.0'
```

`Gemfile.erb` renders this as one self-contained, literal `if puppet_module? ... else ... end` block, placed after (and structurally independent of) the normal `required`/`optional` groups rendering — not interleaved into it. Each branch simply re-opens whichever `group :name do ... end` blocks it needs.  This ensures that the architecture choice is not permanently baked in at scaffold time.  In other words, the rendering produces a single `Gemfile` that resolves either architecture depending on `metadata.json` at `bundle install` time.

```ruby
if puppet_module?
  group :development do
    gem "voxpupuli-puppet-lint-plugins", '~> 7.0', require: false
  end
  group :development, :release_prep do
    gem "puppetlabs_spec_helper", '~> 9.0', require: false
  end
else
  group :development do
    gem "voxpupuli-puppet-lint-plugins", '~> 6.0', require: false
  end
  group :development, :release_prep do
    gem "puppetlabs_spec_helper", '~> 8.0', require: false
  end
end
```

`Rakefile.erb`'s `require` is driven by `puppet_module?` alone.  If the expected gem isn't there, this fails immediately with an exact `LoadError` naming the missing file.

```ruby
require(puppet_module? ? 'puppetlabs-syntax/tasks/puppetlabs-syntax' : 'puppet-syntax/tasks/puppet-syntax')
```

The `voxpupuli-puppet-lint-plugins` split exists because the two generations aren't independent: `voxpupuli-puppet-lint-plugins ~> 7.0` requires `puppet-lint ~> 5.1`, while `puppetlabs_spec_helper < 9.0` requires `puppet-lint ~> 4.0` — pinning only `puppetlabs_spec_helper` and leaving `voxpupuli-puppet-lint-plugins` at its unconditional `~> 7.0` makes the OpenVox branch of the Gemfile **unresolvable**.

Sample table as follows:

| `metadata.json` | `puppetlabs_spec_helper` | syntax gem | `voxpupuli-puppet-lint-plugins` | `puppet-lint` | `rake syntax:manifests` |
|---|---|---|---|---|---|
| `{"name": "puppet"}` or absent | 9.0.0 | `puppetlabs-syntax` 7.2.1 | 7.0.0 | 5.1.1 | passes |
| `{"name": "openvox"}` | 8.0.0 | `puppet-syntax` 4.1.1 | 6.0.0 | 4.3.0 | passes |

See [[0002-auto-patch-a-stale-puppet-requirement-ceiling-via-moduleroot-metadata-json-erb|ADR 0002]] for how a puppet-architecture module's own `metadata.json` requirement is kept in sync with this decision.

## Consequences

- Existing modules that declare `{"name": "puppet", ...}` (the common case in this organisation) or declare no requirement at all now move onto `puppetlabs-syntax`/9.x automatically the next time their `Gemfile.lock` is regenerated (`pdk update` + `bundle update`, or a fresh `bundle install`) — no `.sync.yml` edit, no manual gem pin, no PDK release needed.
- A module must *actively* declare `{"name": "openvox", ...}` to stay on the older, Vox-Pupuli-maintained generation. This is a deliberate default: the organisation's own modules overwhelmingly declare `puppet`, and the safer default is forward (current, Puppet Inc.-maintained gems) rather than backward.
- Every additional gem that turns out to have divergent puppet-vs-openvox-compatible version ranges (the `voxpupuli-puppet-lint-plugins`/`puppet-lint` chain being the first discovered, not necessarily the last) must be added to `architecture_gems`, under the correct Bundler group, or the affected architecture's `Gemfile` silently becomes unresolvable again. `config_defaults.yml` is not a place this can be detected statically — it can only be caught by actually running `bundle install` against both branches, as done here.
- `Rakefile.erb`'s single `require` and the `Gemfile`'s gem selection are now driven by the exact same `puppet_module?` decision, so the two files can't drift into contradicting each other about which architecture a module is — and a genuine mismatch (gem declared but not actually installed) surfaces as an immediate `LoadError`, not a swallowed no-op. There is deliberately no proactive check for the *other* generation's gem also being loaded (see Decision) — out of scope for now.
- This decision does not touch `pdk-private` (the PDK gem/CLI) at all — see [[explanation_pdk_templates_puppetlabs_spec_helper_version_routing_for_puppet_vs_openvox]] for the fuller reasoning on why the routing belongs in the template layer rather than the CLI.
