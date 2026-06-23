# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This repository contains the default templates used by [Puppet Development Kit (PDK)](https://github.com/puppetlabs/pdk) to create, convert, and update Puppet modules.

## Key Directory Layout

- `moduleroot/`: Full module templates deployed on `pdk new module`, `pdk convert`, and `pdk update`. Enforces boilerplate for central files.
- `moduleroot_init/`: Skeleton templates deployed only when the target module does not yet exist (required by `pdk convert`; do not remove).
- `object_templates/`: Templates for generated objects (classes, defined types, tasks, plans, functions, transports, providers).
- `config_defaults.yml`: The canonical source of default template configuration consumed by PDK.
- `.ci/`: CI scripts (`install_pdk.sh`, `test_script.sh`) and fixtures.

## Commands

Lint this repository's Ruby files (RuboCop is the only local tooling):

```bash
bundle install
bundle exec rubocop
```

Full integration testing requires PDK installed and mirrors what CI does in `.ci/test_script.sh`:

```bash
# Note: this creates a real branch in your working tree
git checkout -b ci_commit

TEMPLATE_DIR=$PWD
pdk new module my_test_module --template-url="file://$TEMPLATE_DIR" --template-ref=ci_commit --skip-interview

pushd my_test_module
pdk validate
pdk test unit
popd
```

## Architecture: How Templates Are Rendered

PDK merges two YAML files to produce a configuration hash before rendering any template:

1. `config_defaults.yml` — repository-level defaults
2. `.sync.yml` in the target module — per-module overrides

The merged result is exposed inside every ERB template as the `@configs` hash. Top-level keys in this hash correspond to target file paths (e.g., `Gemfile`, `.rubocop.yml`). Templates access their own config via `@configs['key']`. A special `common` key holds settings that apply across all templates.

Module maintainers use the [knockout prefix](https://www.rubydoc.info/gems/puppet/DeepMerge) `---` in `.sync.yml` to remove values set by `config_defaults.yml`:
- Remove an array element: prefix the value with `---`
- Remove a hash key: set its value to `'---'`

The `unmanaged: true` key tells PDK to leave a file untouched; `delete: true` tells it to remove the file from the module.

## Editing Expectations

- Preserve ERB syntax and existing placeholder patterns.
- Keep template behavior backward compatible unless a change request explicitly calls for a breaking change.
- Prefer minimal, targeted edits over broad refactors.
- Use plain ASCII unless the file already requires unicode characters.
- Many templates read values from `@configs`; avoid hardcoding values that should remain configurable.
- When editing `moduleroot/.github/workflows/*.erb`, third-party GitHub Actions must reference the `puppetlabs`-forked copies (on `pdk-templates-v1` branches), not upstream. See the README's "Security Considerations on Github Actions" section for the rationale and list of forked actions.

## RuboCop Profile System

`moduleroot/.rubocop.yml.erb` uses `deep_merge` to layer configuration in the order `defaults -> profile['configs'] -> cop_overrides` before rendering the final `.rubocop.yml`:

- `default_configs`: a YAML anchor in `config_defaults.yml` holding the base EnforcedStyle tunings that the `'on'` profile reuses as its `configs` (resolved when `config_defaults.yml` is assembled, not read directly at render time). The anchor also tunes several PDK / rspec-puppet-convention cops (e.g. trailing-comma style, the rspec-puppet describe/context/double idioms) so that freshly-scaffolded modules validate clean under `NewCops: enable`. Each such tuning carries an inline `Description:` rationale explaining why it exists; do NOT remove those `Description:` lines, as they prevent future drift and accidental re-enabling.
- `profiles`: defined in `config_defaults.yml` under `.rubocop.yml.profiles`. Two profiles exist: `'on'` (canonical; `NewCops: enable`) and `'off'` (`DisabledByDefault: true`, `NewCops: disable`). The names `cleanups_only`, `strict`, and `hardcore` are backward-compatible aliases that resolve to `'on'`.
- `cop_overrides`: the authoritative per-module override surface, merged last. Use `CopName: { Enabled: false }` to disable a cop; use the knockout prefix `---` to remove an override. The same `---` prefix applies to both PDK's `.sync.yml` overlay (the outer PDK merge) and this template's internal `defaults -> profile -> cop_overrides` deep-merge, so there is one knockout prefix everywhere.
- `selected_profile`: chooses which profile is active (ships as `strict`, a backward-compatible alias that resolves to `'on'`). Set to `'off'` to disable all cops.

**Future improvements:** The convention tunings above cover the object types that `.ci/test_script.sh` actually scaffolds and validates. Object types NOT currently exercised by CI -- notably `plan` and the legacy V1 `function` -- were intentionally left untouched: there is no scaffold coverage to validate a change against, so fixing them speculatively would be unverifiable. They are candidates for future template-validation coverage once CI scaffolds them.

## Packaging and Release Context

In PDK packages, pdk-templates ships as a bare git repo at `share/cache/pdk-templates.git` (pre-bundled by pdk-vanagon-private). Gems from the template's `Gemfile` are pre-cached per Ruby version at package build time.

The current pinned ref is tracked in `configs/components/pdk-templates.json` inside `pdk-vanagon-private`. To test a pre-release build against a specific commit, update the `ref` SHA in that file manually and trigger a Jenkins build.

**Versioning convention:** If only the `Gemfile` changes between full releases (e.g. a dependency fix), cut a 4th version digit (e.g. `3.6.1.1`) rather than bumping the full PDK version.

**Release tag order:** pdk-templates must be tagged *before* pdk-private in a full release, because pdk-private's metadata references the pdk-templates version.

## Documentation Guidance

If you change template behavior, update:
- `README.md` for user-facing behavior and supported configuration keys.
- `docs/` for behavior-specific implementation details.

## Project Rules

- At the start of a coding session, review the repository structure and any relevant README or documentation files to understand the area you are working in.
- Always read the files relevant to the task before suggesting or making a change.
- Never merge a pull request.
- Never work directly on the `main` or `master` branch.
- Never push a branch without explicit instruction.
- Never delete a file without permission — this applies even after a blanket "yes to all".
- Never output, log, save, or hardcode security-sensitive values — this includes passwords, tokens, API keys, private keys, secrets, and credentials of any kind. Do not write them to files, include them in commit messages, or print them in responses.
