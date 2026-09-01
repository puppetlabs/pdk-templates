---
tags:
  - -jira/bolt/193/bolt-migrate-to-puppet9/inbox
  - -scope/implementation
---
# 0002. Auto-patch a stale puppet requirement ceiling via moduleroot/metadata.json.erb

Date: 2026-09-01

## Status

Accepted

## Context

After a puppet-architecture module `pdk update`, the `pdk-templates` successfully update the gems to puppet 9 but fail to update the new puppet version requirement in the `metadata.json` .  In other words, although the gems definitions had been update the `metadata.json` still capped the `puppet` requirement below `< 9.0.0`.  This caused CI to ignore the `puppet 9` and `ruby 4.x` testing stream.  

The puppet boundary belongs in `pdk-templates`, not somewhere else, because this is also where every puppet-related gem dependency is defined.  Since the `pdk update` passes a hash of the existing metadata to the `pdk-templates`, then one way to update the puppet requirements is via a new `metadata.json.erb`.

## Decision

Therefore, `moduleroot/metadata.json.erb` was added that reads that same hash, corrects the `puppet` requirement's upper bound to `< 10.0.0`, and re-serializes the `metadata.json` 

## Consequences

- Existing modules with a stale `puppet` requirement ceiling get it corrected automatically on their next `pdk update`, with zero `pdk-private` change, using the same template-rendering pipeline that already renders `Gemfile`/`Rakefile`.

