# 0001. Route Gemfile puppetcore gem selection by resolved gemsource, not by env-var provenance

Date: 2026-09-07

## Status

Accepted

## Context

Recently, modules using a puppetcore gemsource ruby 3 began automatically resolving `puppet` to an older version `<= 8.16` instead of the expected `8.21`.  The cause of this was that puppet 8.17 capped its own `multi_json` dependency at `<= 1.19.0`. Left unconstrained, Bundler resolves `multi_json`'s latest (`1.21.0`) first and silently backtracks `puppet` to whatever old release has no `multi_json` dependency at all — an old `8.x` release, not the intended newer one.  Fortunately on puppetcore and ruby 4, `puppet` resolves correctly to `~> 9.0`.

Although the solution for `puppet` is simple—raise `puppet`'s floor from `8.11` to `8.17`—the module Gemfile must continue to work with multiple puppetcore gem sources, <https://rubygems.org>, and different Ruby versions.

Therefore 2 questions must be answered at bundler Gemfile resolution:

- **is the gemsource that will actually serve this `bundle install` a puppetcore-capable one, or the plain public `rubygems.org`?**
- **which Ruby version are we on, 3 or 4?**

Several puppetcore gating strategies were investigated at first but ruled out, e.g., switching on `ENV['PUPPET_FORGE_TOKEN']` or even on the module's own `metadata.json` content.  A simple strategy was selected:  When `gemsource_puppetcore` is **NOT** equal to <https://rubygems.org>, then bundler will assume puppetcore gemsource.

## Decision

Therefore, `gemsource_puppetcore != 'https://rubygems.org'` was added to the Gemfile to select puppetcore or public; and additional ruby version checking enables the correct selection of `puppet`:

- `8.10` for <https://rubygems.org>
- `~> 8.17` for ruby 3 and puppetcore
- `~> 9.0` for ruby 4 and puppetcore

**NOTE**: This design assumes that `gemsource_puppetcore` other than `https://rubygems.org` is puppetcore.  This was chosen for several reasons: one.  Since we have multiple puppetcore sources (<https://rubygems-puppetcore.puppet.com>, <https://artifactory.delivery.puppet.net/.../rubygems>, etc), then anything other than public gemsource `https://rubygems.org` is assumed to be puppetcore.  If, however, the gemsource is different from the public gemsource and not one of our valid puppetcore sources, then the bundler Gemfile resolution will simply fail loudly.  This is by design.

## Consequences

The above design solves not only the selection of `puppet` but also the selection of 2 associated dev/test gems `voxpupuli-puppet-lint-plugins`, `puppetlabs_spec_helper`.  These 2 gems must move together for puppetcore gemsources.
