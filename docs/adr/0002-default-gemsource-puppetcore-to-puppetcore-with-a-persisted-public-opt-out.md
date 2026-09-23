# 0002. Default gemsource_puppetcore to puppetcore with a persisted public opt-out

Date: 2026-09-23

## Status

Accepted

## Context

ADR 0001 decides which gem versions to select once `gemsource_puppetcore` is known; it does not
address how `gemsource_puppetcore` itself resolves. Previously the template gated puppetcore on
the presence of `ENV['PUPPET_FORGE_TOKEN']`, so the rendered `source:` declaration varied with
ambient environment rather than being a property of the template. A packaged, airgapped PDK
install carries a vendored gem cache built with puppetcore provenance but holds no token, so it
resolved to public `rubygems.org` and could not satisfy those gems from its own cache.
`https://rubygems-puppetcore.puppet.com` returns 401 to all anonymous requests, so there is no anonymous-read fallback.

Routing by the module's own `metadata.json` was ruled out because it conflates the module's
target with network reachability and collides with Bundler's frozen-mode drift checks. A
network-probe fallback to public was ruled out because it duplicates Bundler's native mirror
fallback less well, and introduces render-time non-determinism plus real timeout waits on exactly
the airgapped hosts it was meant to help.

## Decision

`gemsource_puppetcore` resolves to `https://rubygems-puppetcore.puppet.com` unconditionally. The
persisted Bundler setting `gemsource.public`, read via `Bundler.settings['gemsource.public']` and
set once with `bundle config set gemsource.public true`, routes it instead to
`gemsource_default`, which is `ENV['GEM_SOURCE']` falling back to `https://rubygems.org`.
`ENV['GEM_SOURCE_PUPPETCORE']` was removed entirely with no replacement -- an accepted breaking
change.

**NOTE**: Bundler warns when none of `PUPPET_FORGE_TOKEN`,
`BUNDLE_RUBYGEMS___PUPPETCORE__PUPPET__COM`, `gemsource.airgapped` or `gemsource.public` is
present, so a credential-less user on a networked install gets an actionable pointer to the
opt-out instead of a bare Bundler 401.

## Consequences

The rendered `source:` declaration is now byte-identical across machines and network conditions,
so a committed `Gemfile.lock` cannot drift into a frozen-mode hard failure. ADR 0001's downstream
gating on `gemsource_puppetcore != "https://rubygems.org"` composes unchanged under both the
default and the opt-out, so `config_defaults.yml` needed no change. Users who previously relied on
leaving `PUPPET_FORGE_TOKEN` unset to get public gems must now set the opt-out explicitly.
