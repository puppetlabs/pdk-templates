# Demo: PDK Puppet 9 / Ruby 4 compatibility checks

A short (~2 minute) walkthrough showing module code that **fails** `pdk validate`
because of Puppet 9 / Ruby 4 incompatibilities, then the corrected code that
**passes**. Tracks [CAT-2683](https://perforce.atlassian.net/browse/CAT-2683).

Puppet 9 ships Ruby 4.0, which removes or changes several long-standing
behaviours. This demo covers the three the ticket calls out:

| # | Issue | Severity | Caught by `pdk validate`? | Cop |
| - | ----- | -------- | ------------------------- | --- |
| 1 | `Kernel.open` pipe subprocess | Hard break (`NoMethodError`) | **Yes** | `Security/Open` |
| 2 | `Hash#inspect` format reliance | Silent test drift | **Yes** | `HashInspect/LegacyHashInspectFormat` |
| 3 | Bundled gem `require` failures | Hard break (`LoadError`) | **No** (gap) | none yet |

> **Verified against:** `pdk 3.7.0` (bundled Ruby 3.2.11, RuboCop 1.73.2) and
> pdk-templates ref `CAT-1698-rubocop-templates`. Issues #1 and #2 are real
> `pdk validate ruby` fail-then-pass transitions; issue #3 is shown as a gap
> (validation stays green) plus the grep/runtime detection the ticket lists.

## Run it

A self-verifying script performs every step below and asserts the expected
pass/fail at each stage (it exits non-zero if a cop ever stops firing, so it
also works as a regression check):

```bash
docs/demos/puppet9-compatibility-demo.sh
# or against an explicit ref:
docs/demos/puppet9-compatibility-demo.sh "file://$PWD" CAT-1698-rubocop-templates
```

## Why this template ref

The compatibility cops were added to pdk-templates in CAT-2635
(`rubocop-hash_inspect` gem) and CAT-2637 (`Security/Open` + `Security/IoMethods`),
both of which are on `main`. The demo pins to `CAT-1698-rubocop-templates`
because that branch *also* carries the convention tunings that let a freshly
scaffolded module validate clean under `NewCops: enable` -- so the only
failures you see are the bad code we inject, not pre-existing noise. Once
CAT-1698 merges, re-point the demo at `main` or a release tag.

## Setup (what the script does first)

```bash
TEMPLATE_DIR=$PWD                       # this pdk-templates checkout
pdk new module demo_mod \
  --template-url="file://$TEMPLATE_DIR" \
  --template-ref=CAT-1698-rubocop-templates \
  --skip-interview
cd demo_mod
pdk validate ruby                       # clean: a new module has no lib/*.rb yet
```

---

## Issue #1 -- `Kernel.open` pipe subprocess

Ruby 4 removes the ability to spawn a subprocess by passing a pipe-prefixed
string to `Kernel.open` / `open()` ([Ruby #19630](https://bugs.ruby-lang.org/issues/19630)).
The `Security/Open` cop flags it.

### Bad -- `lib/facter/disk_usage.rb`

```ruby
# frozen_string_literal: true

Facter.add(:disk_usage) do
  setcode do
    output = open('| df -h /').read   # '|' prefix -> subprocess; gone in Ruby 4
    output.split("\n").last.split[4]
  end
end
```

```console
$ pdk validate ruby
pdk (CONVENTION): rubocop: The use of `Kernel#open` is a serious security risk. (lib/facter/disk_usage.rb:5:14)
# exit 1
```

### Good

```ruby
# frozen_string_literal: true

Facter.add(:disk_usage) do
  setcode do
    output = IO.popen(['df', '-h', '/'], &:read)   # explicit subprocess intent
    output.split("\n").last.split[4]
  end
end
```

```console
$ pdk validate ruby
# exit 0 -- clean
```

* `IO.popen` declares subprocess intent explicitly and works on Ruby 3.2 and 4.0.
* The **array** form (`['df', '-h', '/']`) avoids shell interpretation and
  command injection.
* Use `&:read` rather than `{ |pipe| pipe.read }` -- the explicit block form
  would itself trip RuboCop's `Style/SymbolProc` cop. (The ticket's example
  uses the block form; this corrected version is the one that actually
  validates clean.)

### Known cop gaps (worth saying out loud in the demo)

`Security/Open` flags `open("| cmd")` and `open(var)`, but **not** the
explicit-receiver `Kernel.open(...)` form, nor the deliberate `IO.read("| cmd")`
form. For those, the manual backup catches the rest:

```bash
grep -rn 'Kernel\.open' lib/
grep -rn 'IO\.read.*|' lib/
```

---

## Issue #2 -- `Hash#inspect` format reliance

Ruby 3.4 changed `Hash#inspect` from `{:sym=>val}` to `{sym: val}`
([Ruby #20433](https://bugs.ruby-lang.org/issues/20433)). Tests that
string-match the old format pass on 3.2 and **silently** fail on 3.4+ / Ruby 4.
The `HashInspect/LegacyHashInspectFormat` cop (from the `rubocop-hash_inspect`
gem) catches the hardcoded legacy strings statically.

### Bad -- `spec/unit/disk_usage_spec.rb`

```ruby
# frozen_string_literal: true

require 'spec_helper'

describe 'config rendering' do
  it 'renders the config' do
    content = '{:database=>"prod", :port=>5432}'
    expect(content).to include('{:database=>"prod", :port=>5432}')
  end
end
```

```console
$ pdk validate ruby
pdk (CONVENTION): rubocop: Legacy `Hash#inspect` format (`{:sym=>...}`). Ruby 3.4+ renders hashes as `{sym: ...}`, so this hardcoded value breaks on Ruby 3.4 / Puppet 9. Update it to the new format. (spec/unit/disk_usage_spec.rb:7:15)
pdk (CONVENTION): rubocop: Legacy `Hash#inspect` format (`{:sym=>...}`). ... (spec/unit/disk_usage_spec.rb:8:32)
# exit 1
```

### Good

```ruby
# frozen_string_literal: true

require 'spec_helper'

describe 'config rendering' do
  it 'renders the config' do
    content = '{database: "prod", port: 5432}'   # new Ruby 3.4+ format
    expect(content).to include('{database: "prod", port: 5432}')
  end
end
```

```console
$ pdk validate ruby
# exit 0 -- clean
```

* The cleanest long-term fix is to **not** match `inspect` output at all --
  compare structured data instead (e.g. parse the content and
  `expect(parsed).to include(database: 'prod', port: 5432)`), so the assertion
  is immune to any future inspect change.
* Updating the literal to the new format (shown above) is the minimal fix and
  is what the cop steers you toward.

---

## Issue #3 -- Bundled gem `require` failures (the gap)

Ruby 4 moves `csv`, `logger`, `ostruct`, `benchmark`, and `racc` from default
gems (always available) to **bundled** gems (must be declared). A bare
`require 'csv'` then raises `LoadError` at runtime on Ruby 4.

**There is no cop for this yet** -- a future cop (repurposed from CAT-2636)
could automate it. So in the demo this step deliberately shows validation
staying **green**, to make the gap explicit:

### Code -- `lib/facter/csv_fact.rb`

```ruby
# frozen_string_literal: true

require 'csv'

Facter.add(:first_csv_field) do
  setcode do
    rows = CSV.read('/etc/my_app/config.csv')
    rows.first&.first
  end
end
```

```console
$ pdk validate ruby
# exit 0 -- PASSES. PDK does not flag the undeclared 'csv' require.
```

### Detection (manual, today)

```bash
grep -rn "require 'csv'"      lib/ spec/
grep -rn "require 'logger'"   lib/ spec/
grep -rn "require 'ostruct'"  lib/ spec/
grep -rn "require 'benchmark'" lib/ spec/
grep -rn "require 'racc'"     lib/ spec/
```

### Fix -- declare the dependency (the Ruby code is unchanged)

```ruby
# Gemfile
gem 'csv', '~> 3.0'
gem 'ostruct', '~> 0.6'
```

* For `spec/` code, adding to the `Gemfile` is sufficient.
* For `lib/` (runtime) code, the Puppet agent's Vanagon-packaged Ruby typically
  bundles these gems; the real risk is standalone Ruby running outside the
  agent. Declaring them is a harmless, backward-compatible fix on Ruby 3.2.

---

## Takeaways for the demo narration

1. **#1 and #2 are caught now** -- a real fail-then-pass under `pdk validate ruby`,
   straight out of an updated module.
2. **#3 is a known gap** -- validation stays green; detection is grep + a
   runtime `LoadError`. Honest framing here is the point, not a weakness.
3. The cops travel with the template: a module gets them on its next
   `pdk update` once it tracks a pdk-templates version that carries them.
