# PDK Templates

[![Code Owners](https://img.shields.io/badge/owners-DevX--team-blue)](https://github.com/puppetlabs/pdk-templates/blob/main/CODEOWNERS)
![ci](https://github.com/puppetlabs/pdk-templates/actions/workflows/ci.yml/badge.svg)

The pdk-templates repository contains the default templates (or blueprints) used by the [Puppet Development Kit](https://github.com/puppetlabs/pdk) to create, convert, and update modules. 

The following table shows the directories where different types of template are stored. 

|                   |               |
| :-----------------|:--------------|
| `moduleroot`      | Stores templates that are deployed on pdk new module, pdk convert and pdk update commands. Use the templates in this directory to enforce a common boilerplate for central files. |
| `moduleroot_init` | Stores light versions of moduleroot templates. The templates in this directory create a skeleton for the files the developer will need. Deploy these templates when the target module does not yet exist. |
| `object_templates`| Stores templates that are used by the various new <something> commands. These are in charge of building classes, defined types, etc |

Use this README to understand the purpose, basic usage, and common configurable values for PDK templates. For further information about PDK, refer to our [documentation site](https://www.puppet.com/docs/pdk/2.x/pdk.html).

#### Table of contents

* [Introduction](#pdk-templates)
* [How templates are used by PDK](#how-templates-are-used-by-pdk)
* [Basic usage](#basic-usage)
* [Adjusting templates via /sync.yml](#adjusting-templates-via-syncyml)
  * [Adding configuration values](#adding-configuration-values)
  * [Removing default configuration values](#removing-default-configuration-values)
  * [Excluding files from default behaviour](#excluding-files-from-default-behaviour)
  * [Unmanaged and delete keys](#unmanaged-and-delete-keys)
  * [Setting custom gems in the Gemfile](#setting-custom-gems-in-the-gemfile)
  * [Manage Rubocop rules](#manage-rubocop-rules)
* [PDK default config values](#pdk-default-config-values)
* [Further Notes](#further-notes)

## How templates are used by PDK

When you use PDK to build, convert, or update a module, PDK accesses the relevant template in the pdk-templates repository to retrieve default “instructions” on how to build the module. Those instructions are applied to the local repo in which the command was run. 

When configuring the module, PDK reads a set of default settings in `.config_defaults.yml` and merges it with the configuration settings in `.sync.yml`.

The result of this merge creates a hidden hash containing the final configuration of the module that PDK applies. Top-level keys of this resulting hash correspond to target files. A global configuration is merged with the configuration hash for a particular target file. This allows module developers to override or amend the configuration by adding new values through `.sync.yml`. For example, a knockout prefix (---) can be applied to keys in `.sync.yml` to remove default configuration values. 

Target files are created by rendering a corresponding template which refers its configuration via the `@configs` hash.

You can configure PDK to make files executable if the file is executable in the template. To do this, include `manage_execute_permissions: true` either in the target file or globally via the common config key.

## Basic Usage

By default PDK uses the templates within this repository to render files for use within a module. To use a third-party template, pass its URL using the `–-template-url` flag as shown in the following example: 

```bash
pdk convert --template-url https://github.com/puppetlabs/pdk-templates
```

Note: Commands run on PDK will use the last specified template repository. 

When you have specified the template repository, you can get started with creating a module, if you don't already have one. Once your module is created, you can customize PDK-templates by editing the `.sync.yml` to override the default configuration, and then running `PDK update` on the module so that the new settings are applied.

For more information on basic usage and more detailed description of PDK in action please refer to [PDK documentation](https://github.com/puppetlabs/pdk/blob/main/README.md), where you can find detailed instructions on how to create, convert and update modules, as well as other useful commands.

## Adjusting templates via /sync.yml

> While we provide a basic template it is likely that it will not match what you need exactly, as such we allow it to be altered or added to through the use of the `.sync.yml` file.

Here we will provide some examples of how you can use `.sync.yml`. For a more comprehensive list of default settings, check the [PDK default config values](#pdk-default-config-values) section. 

### Adding configuration values

Values can be added to the data passed to the templates, thus allowing you to make changes such as testing against additional operating systems or adding new rubocop rules.

To add a value to an array simply place it into the `.sync.yml` file as shown below, here is the structure to add an additional unit test run against Puppet 4:

```yaml
.travis.yml:
  includes:
    - env: PUPPET_GEM_VERSION="~> 4.0" CHECK=parallel_spec
      rvm: 2.1.9
```

### Removing default configuration values

Values can be removed from the data passed to the templates using the [knockout prefix](https://www.rubydoc.info/gems/puppet/DeepMerge) `---` in `.sync.yml`.

To remove a value from an array, prefix the value `---`. For example, to remove
`2.5.1` from the `ruby_versions` array in `.travis.yml`:

```yaml
.travis.yml:
  ruby_versions:
    - '---2.5.1'
```

To remove a key from a hash, set the value to `---`. For example, to remove the
`ip` fact from `spec/default_facts.yml`:

```yaml
spec/default_facts.yml:
  networking:
    ip: '---'
```

### Excluding files from default behaviour 

You can also configure the system to ignore specific files when performing default configuration. For example, we can prevent all `.erb` files from being targeted by the `.gitattributes` group settings by using: 

```yaml
".gitattributes": 
  exclude: 
  - "*.erb"
```

### Unmanaged and delete keys 

The `unmanaged` and `delete` keys also allow you to override default configurations. The `unmanaged` key allows you to specify files that are to be left untouched by the conversion or update, and `delete` allows you to specify that a file should be excluded from the module when you convert or update the module. 

In the following example, the `unmanaged` and `delete` keys are used to specify that, regardless of the default setting defined in `config_defaults.yml`, PDK should leave the `ci.yml` file unmodified and delete `travis.yml`. 

```yaml
.github/workflows/ci.yml: 
  unmanaged: true 
```

```yaml
.travis.yml: 
  delete: true
```
### Setting custom gems in the Gemfile

To add a custom internal `puppet-lint` plugin served from an internal Rubygems source, add
an entry similar to the following in `.sync.yml` file and run `pdk update`.

```yaml
Gemfile:
  optional:
    ':development':
      - gem: 'puppet-lint-my_awesome_custom_module'
        version: '>= 2.0'
        source: 'https://myrubygems.example.com/'
```

### Manage Rubocop rules

To disable or enable certain Rubocop rules, use the following structure:

```yaml
.rubocop.yml:
  default_configs:
    Rule/Name:
      Enabled: true/false
```

## PDK default config values

The following is a description and explanation of each of the keys within `.config_defaults.yml`. This will help clarify the default settings that are applied by PDK. 

> All the values defined below can be overriden through `.sync.yml`.

### common

>Settings common to all templates

| Key               | Description   |
| :-----------------|:--------------|
| manage_execute_permissions | Templates with execute permissions will be made executable in the module.|

### .gitattributes

>A .gitattributes file in your repo allows you to ensure consistent git settings.

| Key               | Description   |
| :-----------------|:--------------|
| include           | Defines which extensions are handled by git automatic conversions (see the [gitattributes](https://git-scm.com/docs/gitattributes) documentation). The default configuration helps to keep line endings consistent between windows and linux users.|

### .gitignore

>A .gitignore file in your repo allows you to specify intentionally untracked files to ignore.

| Key               | Description   |
| :-----------------|:--------------|
| required          | The default list of files or paths for git to ignore or untrack that are commonly specified in a module project.
| paths             | Defines any additional files or paths for git to ignore or untrack. (see the [gitignore](https://git-scm.com/docs/gitignore) documentation).

### Github Workflows

> These workflows are depending on puppet-internal resources and are currently not suited for public consumption. Feel free to take them as inspiration how to run some tests on Github Actions. Please let us know at <ia_content@puppet.com> what you come up with!

### .github/workflows/release_prep.yml

> The auto release workflows prepares a module release PR. By default the workflow can be triggered manually when a release preparation PR needs to be created, however it allows setting a cron based trigger that can run automatically. To set up the automated release cron you can add a configuration to your .sync.yml file that matches the following example:
```yaml
release_schedule:
   cron: '0 3 * * 6'
```
In this example the automated release prep workflow is triggered every Saturday at 3 am.

### .pdkignore

>A .pdkignore file in your repo allows you to specify files to ignore when building a module package with `pdk build`.

| Key               | Description   |
| :-----------------|:--------------|
| required          | The default list of files or paths for PDK to ignore when building a module package.
| paths             | Defines additional files or paths for PDK to ignore when building a module package.

### .yardopts

>[YARD](https://yardoc.org/) is a documentation generation tool for the Ruby programming language. It enables the user to generate consistent, usable documentation that can be exported to a number of formats very easily, and also supports extending for custom Ruby constructs such as custom class level definitions.

| Key            | Description   |
| :------------- |:--------------|
| markup         |Specifies the markup formatting of your documentation. Default is `markdown`.|
| optional       |Define any additional arguments you want to pass through to the `yardoc` command.|

### Rakefile

>[Rake](https://github.com/ruby/rake) is a Make-like program implemented in Ruby. Tasks and dependencies are specified in standard Ruby syntax within the Rakefile, present in the root directory of the code repository. Within modules context Rake tasks are used quite frequently, from ensuring the integrity of a module, running validation and tests, to tasks for releasing modules.

| Key            | Description   |
| :------------- |:--------------|
|requires|A list of hashes with the library to `'require'`, and an optional `'conditional'`.|
|changelog\_user|Sets the github user for the change_log_generator rake task. Optional, if not set it will read the `author` from the `metadata.json` file.|
|changelog\_project|Sets the github project name for the change\_log\_generator rake task. Optional, if not set it will parse the `source` from the `metadata.json` file|
|changelog\_since\_tag|Sets the github since_tag for the change\_log\_generator rake task. Required for the `changelog` rake task.|
|changelog\_max\_issues|Sets the github max_issues for the change\_log\_generator rake task. Optional to limit max issues. |
|changelog\_version\_tag\_pattern|Template how the version tag is to be generated. Defaults to `'v%s'` which eventually align with tag\_pattern property of puppet-blacksmith, thus changelog is referring to the correct version tags and compare URLs. |
|github_site|Override built-in default for public GitHub. Useful for GitHub Enterprise and other. (Example: `github_site = https://git.domain.tld`) |
|github_endpoint|Override built-in default for public GitHub. Useful for GitHub Enterprise and other. (Example: `github_endpoint = https://git.domain.tld/api/v4`) |
|default\_disabled\_lint\_checks| Defines any checks that are to be disabled by default when running lint checks. As default we disable the `--relative` lint check, which compares the module layout relative to the module root. _Does affect **.puppet-lint.rc**._ |
|extra\_disabled\_lint\_checks| Defines any checks that are to be disabled as extras when running lint checks. No defaults are defined for this configuration. _Does affect **.puppet-lint.rc**._ |
|extras|An array of extra lines to add into your Rakefile. As an alternative you can add a directory named `rakelib` to your module and files in that directory that end in `.rake` would be loaded by the Rakefile. Example, to add syntax check exclusion paths for plan directories:<pre><br>Rakefile:<br>  extras:<br>  - \'PuppetSyntax.exclude_paths = ["plans/\*\*/*.pp","central/modules/deployments/plans/\*\*/*.pp"]\'</pre>
|linter\_options| An array of options to be passed into linter config. _Does affect **.puppet-lint.rc**._ |
|linter\_fail\_on\_warnings| A boolean indicating if the linter should exit non-zero on warnings as well as failures. _Does affect **.puppet-lint.rc**._ |
|linter_exclusions | An array of paths that the linter should exclude from running against. |

### .rubocop.yml

>[RuboCop](https://github.com/bbatsov/rubocop) is a Ruby static code analyzer. We use Rubocop to enforce a level of quality and consistency within Ruby code. Rubocop can be configured within .rubocop.yml which is located in the root directory of the code repository. Rubocop works by defining a sanitized list of cops that'll cleanup a code base without much effort, all of which support autocorrect and that are fairly uncontroversial across wide segments of the Community.

| Key            | Description   |
| :------------- |:--------------|
|include\_todos|Allows you to use rubocop's "TODOs" to temporarily skip checks by setting this to `true`. See rubocop's `--auto-gen-config` option for details. Defaults to `false`.|
|selected\_profile|Allows you to define which profile is used by default, which is set to `strict`, which is fully defined within the `profiles` section.|
|default\_configs |Allows you to define the default configuration of which cops will run. Includes the full name of the cop followed by a description of it and an enforced style. Can also make use of the key `excludes` to exclude any files from that specific cop.|
|cleanup\_cops    |Defines a set of cleanup cops to then be included within a rubocop profile. Cops are defined by their full name, and further configuration can be done by specifying secondary keys. By default we specify a large amount of cleanup cops using their default configuration.|
|profiles         |Defines the profiles that can be enabled and used within rubocop through the `selected_profile` option. By default we have set up three profiles: cleanups\_only, strict, hardcore and off.|

### Gemfile

>A Gemfile is a file we create which is used for describing gem dependencies for Ruby programs. All modules should have an associated Gemfile for installing the relevant gems. As development and testing is somewhat consistant between modules we have used the template to define a set of gems relevant to these processes.

| Key            | Description   |
| :------------- |:--------------|
|required|Allows you to specify gems that are required within the Gemfile. Gems can be defined here within groups, for example we use the :development gem group to add in several gems that are relevant to the development of any module and the :system_tests gem group for gems relevant only to acceptance testing.|
|optional|Allows you to specify additional gems that are required within the Gemfile. This key can be used to further configure the Gemfile through assignment of a value in the .sync.yml file.|
|overrides|Allows you to specify an array of gems that should override template default gems of the same name. _This is an advanced option which may result in unresolved dependencies or other unexpected interactions._ |

>Within each Gem group defined using the options above one or more gem item definitions may be listed in an array. Each item in that array must be a gem item hash.

| Gem Item Hash Keys | Description  |
| :----------------- |:-------------|
|gem|Required option specifying the gem name.|
|version|Required option to specify version or range of versions required using [RubyGem version syntax](https://guides.rubygems.org/patterns/#pessimistic-version-constraint).|
|platforms|Defines an array of platforms for which the Gem should be included. See the [Gemfile platform guide](https://bundler.io/man/gemfile.5.html#PLATFORMS) for a list of valid platforms.|
|git|If required, specify a specific Git repository in which this Gem is located. See the [Bundler docs](https://bundler.io/man/gemfile.5.html#GIT) for details.|
|branch|Optionally specify a branch to use if using the `git` option. Defaults to `main`.|
|ref|Optionally specify an arbitrary valid Git reference to use for the module version.|
|source|Specify an alternate Rubygems repository to load the gem from.|
|from_env|Specifies an environment variable containing either a Rubygem version specification indicating the version to use OR a URL indicating the location from which to load the gem.|
|condition|An optional string containing a Ruby-code conditional controlling if this gem will be processed in the Gemfile.|

### spec/default_facts.yml

> The spec/default_facts.yml file contains a list of facts to be used by default when running rspec tests

| Key            | Description   |
| :------------- |:--------------|
|ip|Overrides the \[networking\]\[ip\] fact's value in the base template. Defaults to "172.16.254.254".|
|ip6|Overrides the \[networking\]\[ip6\] fact's value in the base template. Defaults to "FE80:0000:0000:0000:AAAA:AAAA:AAAA".|
|mac|Overrides the \[networking\]\[mac\] fact's value in the base template. Defaults to "AA:AA:AA:AA:AA:AA".
|is_pe|Overrides the is_pe fact's value in the base template. Defaults to false.
|extra_facts|List of extra facts to be added to the default_facts.yml file. They are in the form: "`name of fact`: `value of fact`"|

```yaml
---
networking:
  ip: "172.16.254.254"
  ip6: "FE80:0000:0000:0000:AAAA:AAAA:AAAA"
  mac: "AA:AA:AA:AA:AA:AA"
is_pe: false
```

### spec/spec_helper.rb

> The spec/spec_helper.rb file contains setup for rspec tests

| Key            | Description   |
| :------------- |:--------------|
|default_facter_version|Sets the [`default_facter_version`](https://github.com/mcanevet/rspec-puppet-facts#specifying-a-default-facter-version) rspec-puppet-facts parameter.|
|facter_implementation|Sets the [`facter_implementation`](https://github.com/puppetlabs/rspec-puppet#facter_implementation) rspec-puppet parameter. Current available options are `rspec` and `facter`, with `facter` being the default. The `rspec` implementation offers a significant performance improvement and results in faster unit tests.|
|hiera_config|Sets the [`hiera_config`](http://rspec-puppet.com/documentation/configuration/#hiera_config) rspec-puppet parameter.|
|hiera_config_ruby|Sets the [`hiera_config`](http://rspec-puppet.com/documentation/configuration/#hiera_config) rspec-puppet parameter. A ruby expression returning the path to your hiera.yaml file. `hiera_config` takes precedence if both values `hiera_config` and `hiera_config_ruby` are specified. |
|mock_with|Defaults to `':rspec'`. If you need the previous default of "some mocha and some rspec-mocks", set `mock_with: ~` (tilde symbol, the YAML null value).|
|spec_overrides|An array of extra lines to add into your `spec_helper.rb`. Can be used as an alternative to `spec_helper_local`|
|strict_level| Defines the [Puppet Strict configuration parameter](https://puppet.com/docs/puppet/5.4/configuration.html#strict). Defaults to `:warning`. Other values are: `:error` and `:off`. `:error` provides strictest level checking and is encouraged.|
|strict_variables| Defines the [Puppet Strict Variables configuration parameter](https://puppet.com/docs/puppet/5.4/configuration.html#strict_variables). Defaults to `true` however due to `puppetlabs_spec_helper` forced override (https://github.com/puppetlabs/puppetlabs_spec_helper/blob/070ecb79a63cb8fa10f46532c413c055e2697682/lib/puppetlabs_spec_helper/module_spec_helper.rb#L71). Set to `false` to align with true default or with `STRICT_VARIABLES=no` environment setting.|
|coverage_report|Enable [rspec-puppet coverage reports](https://rspec-puppet.com/documentation/coverage/). Defaults to `false`|
|minimum_code_coverage_percentage|The desired code coverage percentage required for tests to pass. Defaults to `0`|

## Further Notes

Please note that the early version of this template contained only a 'moduleroot' directory, and did not have a 'moduleroot\_init'. The PDK 'pdk new module' command will still work with templates that only have 'moduleroot', however the 'pdk convert' command will fail if the template does not have a 'moduleroot_init' directory present. To remedy this please use the up to date version of the template.

[legacy_facts_doc]: https://puppet.com/docs/facter/latest/core_facts.html#legacy-facts

## Security Considerations on Github Actions

As explained in [Use GitHub actions at your own risk](https://julienrenaux.fr/2019/12/20/github-actions-security-risk/),
when running github actions from outside the organisation,
there is a risk that symbolic references get taken over by malicious actors.
Similar things happened before in other ecosystems and other packaging registries.
The blog post goes on to suggest pinning to specific SHAs and provides some tooling to do so.
The downsides for us are that the tooling doesn't work well with our ERB templating,
and the additional cost of updating the SHAs across all modules.
Instead we fork at-risk actions into the puppetlabs namespace and use them from there.
This allows us to consume updates at our pace and deploy changes across all modules without delay,
while avoiding actions that surreptitiously change while we're not looking.

Since this still has some overhead, we exclude some "big-name" action maintainers:
* Anything maintained by Github, e.g. [https://github.com/actions](https://github.com/actions)
* Anything maintained as part of a bigger OSS project we're using, like [https://github.com/ruby/setup-ruby](https://github.com/ruby/setup-ruby)
* Anything maintained by a Puppet employee

### Updating actions guidelines

To keep efforts low when updating actions, we list all forked actions here.
To keep confusion to a minimum, the version we use is always on a `pdk-templates-v1` branch.
This way we can update (`git fetch`/`git push`) forked repositories with no prejudice, test out the changes, and only then update the `pdk-templates-v1` branch.
That said, the branches used in pdk-templates should only contain upstream code and changes already in an upstream PR to minimize the diff we're carrying.
If we later need to support multiple versions of an action as we roll out changes, we can increment the `-v1` part in the branch name to manage multiple versions.

* [kvrhdn/gha-buildevents](https://github.com/kvrhdn/gha-buildevents) ➡️ [puppetlabs/kvrhdn-gha-buildevents](https://github.com/puppetlabs/kvrhdn-gha-buildevents/tree/pdk-templates-v1)
* [Gamesight/slack-workflow-status](https://github.com/Gamesight/slack-workflow-status) ➡️ [puppetlabs/Gamesight-slack-workflow-status](https://github.com/puppetlabs/Gamesight-slack-workflow-status/tree/pdk-templates-v1)

The repos have restricted access only to [@modules](https://github.com/orgs/puppetlabs/teams/modules) team members.
