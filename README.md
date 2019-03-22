# PDK Templates

The PDK Templates is the default templates repository for use with the [Puppet Development Kit](https://github.com/puppetlabs/pdk), within which we have defined all the templates for the creation and configuration of a module. Look into these directories to find the templates:
* `moduleroot` templates get deployed on `new module`, `convert` and `update`; use them to enforce a common boilerplate for central files.
* `moduleroot_init` templates get only deployed when the target module does not yet exist; use them to provide skeletons for files the developer needs to modify heavily.
* `object_templates` templates are used by the various `new ...` commands for classes, defined types, etc.

The PDK also absorbs the `config_defaults.yml` file to apply a set of default configurations to the module. Each top-level key in the file corresponds to a target file, and will be merged with the `:global` section at the top. Within the template evaluation the values are available under `@config`. In the module itself, you can override/amend the values by putting new values into `.sync.yml` in the module's root. You can remove default values by using the [knockout prefix](#removing-default-configuration-values). The data for a target file also use `delete: true` and `unmanaged: true` to remove, or ignore the particular file.

* [Basic usage](#basic-usage)
* [Values of config\_defaults](#values)
* [Making local changes to the Template](#making-local-changes-to-the-template)
* [Further Notes](#notes)

## Basic Usage

Templates like this one can be used in conjunction with the PDK. As default the PDK itself uses the templates within this repository to render files for use within a module. Templates can be passed to the PDK as a flag for several of the commands.

> pdk convert --template-url https://github.com/puppetlabs/pdk-templates

Please note that the template only needs to be passed in once if you wish to change it, every command run on the PDK will use the last specified template.
For more on basic usage and more detailed description of the PDK in action please refer to the [PDK documentation](https://github.com/puppetlabs/pdk/blob/master/README.md).

##  Values of config\_defaults <a name="values"></a>

The following is a description and explaination of each of the keys within config\_defaults. This will help clarify the default settings we choose to apply to pdk modules.

### .gitattributes

>A .gitattributes file in your repo allows you to ensure consistent git settings.

| Key               | Description   |
| :-----------------|:--------------|
| include           | Defines which extensions are handled by git automatic conversions (see the [gitattributes](https://git-scm.com/docs/gitattributes) documentation). The default configuration helps to keep line endings consistent between windows and linux users.|

### .gitignore

>A .gitignore file in your repo allows you to specify intentionally untracked files to ignore.

| Key               | Description   |
| :-----------------|:--------------|
| paths             | Defines which files or paths for git to ignore or untrack. (see the [gitignore](https://git-scm.com/docs/gitignore) documentation). The default configuration helps to set up commonly ignored or untracked files in a module project.

### .gitlab-ci.yml

>[Gitlab CI](https://about.gitlab.com/features/gitlab-ci-cd/) is a continuous integration platform that is free for all open source projects hosted on Github and Gitlab.com, it also has a self-hosted option that is free as well. We can trigger automated pipelines with ever change to our code base in the master branch, other branches, tags, or additional triggers.
Gitlab CI uses a .gitlab-ci.yml file in the root of your repository tell Gitlab CI what jobs to run when in the pipeline.

 Key            | Description   |
| :------------- |:--------------|
| override       |Defines whether your local `.sync.yml` will ignore the default values in pdk-templates. Defaults to `false`|
| defaults/custom | The `defaults` and `custom` keys are special keys used to denote when configuration is coming from `config_defaults.yml` or `.sync.yml`. While it is possible for users to extend the defaults provided by PDK, it's suggested that the user should only use the `custom` key to separate their overrides/extended configuration from the PDK provided defaults. |
| custom_stages  |Defines a custom job stage for when the CI/CD jobs will be executed in the pipeline. By default `syntax` and `unit` are defined unless `override: true`.|
| beaker         |Defines if you want the default, Docker-in-Docker acceptance job added. Can be set to `true` to enable the default `acceptance` job, or you can specify the `variables` and `tags` subkeys. These subkeys function the same as the `global_variables` option and the `tags` subkey found in the `ruby_versions` option.|
| global_variables |Allows you to set any global environment variables for the gitlab-ci pipeline. Currently includes setting the Puppet gem version.|
| cache          | If this setting exists, it expects a single sub-key called `paths`. `paths` is an array of paths that will be cached for each subsequent job. Defaults to `['vendor/bundle']`|
| bundler\_args   |Define any arguments you want to pass through to bundler. The default is `--without system_tests --path vendor/bundle --jobs $(nproc)` which avoids installing unnessesary gems while installing them to the `vendor/bundler.|
| ruby_versions  |Define a list of ruby_versions to test against. Each version can have a series of sub-keys that are options. `checks` is the rake command(s) to run during the job. `puppet_version` sets the PUPPET_GEM_VERSION environment variable. `allow_failure` is an array of `checks` where you want to allow failures. `tags` is an array of Gitlab CI Runner tags.
| custom_jobs    |Define custom Gitlab CI jobs that will be executed. It is recommended that you use this option if you need customized Gitlab CI jobs. Please see the [.gitlab-ci.yml](https://docs.gitlab.com/ce/ci/yaml/README.html) docs for specifics.|
| rubygems_mirror | Use a custom rubygems mirror url |
| image          |Define the Docker image to use, when using the Docker runner. Please see the [Using Docker images](https://docs.gitlab.com/ee/ci/docker/using_docker_images.html) docs for specifics.|

### .pdkignore

>A .pdkignore file in your repo allows you to specify files to ignore when building a module package with `pdk build`.

| Key               | Description   |
| :-----------------|:--------------|
| paths             | Defines which files or paths for PDK to ignore when building a module package. The default configuration helps to set up commonly ignored files in a module project when building a package.

### .travis.yml

>[Travis CI](https://travis-ci.org/) is a hosted continuous integration platform that is free for all open source projects hosted on Github.
We can trigger automated builds with every change to our code base in the master branch, other branches or even a pull request.
Travis uses a .travis.yml file in the root of your repository to learn about your project and how you want your builds to be executed.

| Key            | Description   |
| :------------- |:--------------|
| dist | If specified, it will set the dist attribute. See the [TravisCI documentation](https://docs.travis-ci.com/user/reference/overview/#virtualisation-environment-vs-operating-system) for more details. |
| simplecov      |Set to `true` to enable collecting ruby code coverage.|
| ruby versions  |Define the ruby versions on which you want your builds to be executed.|
| bundler\_args   |Define any arguments you want to pass through to bundler. The default is `--without system_tests` which avoids installing unnessesary gems.|
| env            |Allows you to add new travis job matrix entries based on the included environmnet variables, one per `env` entry; for example, for adding jobs with specific `PUPPET_GEM_VERSION` and/or `CHECK` values.  See the [Travis Environment Variables](https://docs.travis-ci.com/user/environment-variables) documentation for details.|
| global_env     |Allows you to set global environment variables which will be defined for all travis jobs; for example, `PARALLEL_TEST_PROCESSORS` or `TIMEOUT`.  See the [Travis Global Environment Variables](https://docs.travis-ci.com/user/environment-variables/#Global-Variables) documentation for details.|
|docker_sets     |Allows you to configure sets of docker to run your tests on. For example, if I wanted to run on a docker instance of Ubuntu I would add  `set:docker/ubuntu-14.04` to my docker\_sets attribute.  docker_sets is a hash that supports the 'set' and 'testmode' key|
|docker_sets['set']| this should refrence the docker nodeset that you wish to run|
|docker_sets['testmode']| this configueres the `BEAKER_TESTMODE` to use when testing the docker instance.  the two options are `apply` and `agent` if omitted `apply` is used by default|
|docker_defaults |Defines what values are used as default when using the `docker_sets` definition. Includes ruby version, sudo being enabled, the distro, the services, the env variables and the script to execute.|
|stages          |Allows you to specify order and conditions for travis-ci build stages. See [Specifying Stage Order and Conditions](https://docs.travis-ci.com/user/build-stages/#specifying-stage-order-and-conditions).|
|includes        |Ensures that the .travis file includes the following checks by default: Rubocop, Puppet Lint, Metadata Lint.|
|remove_includes |Allows you to remove includes set in config_defaults.yml.|
|branches        |Allows you to specify the only branches that travis will run builds on. The default branches are `master` and `/^v\d/`. |
|branches_except |Allows you to specify branches that travis will not build on.|
|remove_branches |Allows you to remove default branches set in config_defaults.yml.|
|notifications   |Allows you to specify the notifications configuration in the .travis.yml file.|
|remove_notifications   |Allows you to remove default branches set in config_defaults.yml.|
|user|This string needs to be set to the Puppet Forge user name. To enable deployment the secure key also needs to be set.|
|secure|This string needs to be set to the encrypted password to enable deployment. See [https://docs.travis-ci.com/user/encryption-keys/#usage](https://docs.travis-ci.com/user/encryption-keys/#usage) for instructions on how to encrypt your password.|

### .yardopts

>[YARD](https://yardoc.org/) is a documentation generation tool for the Ruby programming language. It enables the user to generate consistent, usable documentation that can be exported to a number of formats very easily, and also supports extending for custom Ruby constructs such as custom class level definitions.

| Key            | Description   |
| :------------- |:--------------|
| markup         |Specifies the markup formatting of your documentation. Default is `markdown`.|
| optional       |Define any additional arguments you want to pass through to the `yardoc` command.|

### appveyor.yml

>[AppVeyor](https://www.appveyor.com/) is a hosted, distributed continuous integration service used to build and test projects hosted on GitHub by spinning up a Microsoft Windows virtual machine. AppVeyor is configured by adding a file named appveyor.yml, which is a YAML format text file, to the root directory of the code repository.

| Key            | Description   |
| :------------- |:--------------|
|appveyor\_bundle\_install|Defines the bundle install command for the appveyor execution run. In our case we use bundle install `--without system_tests` as default, therefore avoiding redundant gem installation.|
|environment|Defines any environment variables wanted for the job run. In our case we default to the latest Puppet 4 gem version.|
|matrix|This defines the matrix of jobs to be executed at runtime. Each defines environment variables for that specific job run. In our defaults we have a Ruby version specfied, followed by the check that will be run for that job.|
|test\_script|This defines the test script that will be executed. For our purposes the default is set to `bundle exec rake %CHECK%`. As appveyor iterates through the test matrix as we defined above, it resolves the variable CHECK and runs the resulting command. For example, our last test script would be executed as `bundle exec rake spec`, which would run the spec tests of the module.|

### Rakefile

>[Rake](https://github.com/ruby/rake) is a Make-like program implemented in Ruby. Tasks and dependencies are specified in standard Ruby syntax within the Rakefile, present in the root directory of the code repository. Within modules context Rake tasks are used quite frequently, from ensuring the integrity of a module, running validation and tests, to tasks for releasing modules.

| Key            | Description   |
| :------------- |:--------------|
|requires|A list of hashes with the library to `'require'`, and an optional `'conditional'`.|
|changelog_user|Sets the github user for the change_log_generator rake task.Optional, if not set it will read the 'author' from the metadata.json file|
|changelog_project|Sets the github project for the change_log_generator rake task.Optional, if not set it will read the 'name' from the metadata.json file|
|changelog_since_tag|Sets the github since_tag for the change_log_generator rake task.Required for the changlog rake task|
|changelog_version_tag_pattern|Template how the version tag is to be generated. Defaults to ```v%s``` which eventually align with tag_pattern property of puppet-blacksmith, thus changelog rake task generated changelog is referring to the correct  |
|default\_disabled\_lint\_checks| Defines any checks that are to be disabled by default when running lint checks. As default we disable the `--relative` lint check, which compares the module layout relative to the module root. _Does affect **.puppet-lint.rc**._ |
|extra\_disabled\_lint\_checks| Defines any checks that are to be disabled as extras when running lint checks. No defaults are defined for this configuration. _Does affect **.puppet-lint.rc**._ |
|extras|An array of extra lines to add into your Rakefile. As an alternative you can add a directory named `rakelib` to your module and files in that directory that end in `.rake` would be loaded by the Rakefile.|
|linter\_options| An array of options to be passed into linter config. _Does affect **.puppet-lint.rc**._ |

### .rubocop.yml

>[RuboCop](https://github.com/bbatsov/rubocop) is a Ruby static code analyzer. We use Rubocop to enforce a level of quility and consistancy within Ruby code. Rubocop can be configured within .rubocop.yml which is located in the root directory of the code repository. Rubocop works by defining a sanitized list of cops that'll cleanup a code base without much effort, all of which support autocorrect and that are fairly uncontroversial across wide segments of the Community.

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
|required|Allows you to specify gems that are required within the Gemfile. Gems can be defined here within groups, for example we use the :development gem group to add in several gems that are relevant to the development of any module.|
|optional|Allows you to specify additional gems that are required within the Gemfile. This key can be used to further configure the Gemfile through assignment of a value in the .sync.yml file.|

### spec/default_facts.yml
> The spec/default_facts.yml file contains a list of facts to be used by default when running rspec tests

| Key            | Description   |
| :------------- |:--------------|
|concat_basedir|Overrides the concat_basedir fact's value in the base template. Defaults to "/tmp".|
|ipaddress|Overrides the ipaddress fact's value in the base template. Defaults to "172.16.254.254".|
|is_pe|Overrides the is_pe fact's value in the base template. Defaults to false.
|macaddress|Overrides the macaddress fact's value in the base template. Defaults to "AA:AA:AA:AA:AA:AA".
|extra_facts|List of extra facts to be added to the default_facts.yml file. They are in the form: "`name of fact`: `value of fact`"|

### spec/spec_helper.rb
> The spec/spec_helper.rb file contains setup for rspec tests

| Key            | Description   |
| :------------- |:--------------|
|hiera_config|Sets the [`hiera_config`](http://rspec-puppet.com/documentation/configuration/#hiera_config) rspec-puppet parameter.|
|mock_with|Defaults to `':mocha'`. Recommended to be set to `':rspec'`, which uses RSpec's built-in mocking library, instead of a third-party one.|
|spec_overrides|An array of extra lines to add into your `spec_helper.rb`. Can be used as an alternative to `spec_helper_local`|
|strict_level| Defines the [Puppet Strict configuration parameter](https://puppet.com/docs/puppet/5.4/configuration.html#strict). Defaults to `:warning`. Other values are: `:error` and `:off`. `:error` provides strictest level checking and is encouraged.|
|coverage_report|Enable [rspec-puppet coverage reports](https://rspec-puppet.com/documentation/coverage/). Defaults to `false`|
|minimum_code_coverage_percentage|The desired code coverage percentage required for tests to pass. Defaults to `0`|

## Making local changes to the template

> While we provide a basic template it is likely that it will not match what you need exactly, as such we allow it to be altered or added to through the use of the `.sync.yml` file.

### Adding configuration values

Values can be added to the data passed to the templates by adding them to your local `.sync.yml` file, thus allowing you to make changes such as testing against additional operating systems or adding new rubocop rules.

To add a value to an array simply place it into the `.sync.yml` file as shown below, here I am adding an additional unit test run against Puppet 4:

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
`ipaddress` fact from `spec/default_facts.yml`:

```yaml
spec/default_facts.yml:
  ipaddress: '---'
```

## Enabling Beaker system tests

To enable the ability to run Beaker system tests on your module, add the
following entry to your `.sync.yml` and run `pdk update`.

```yaml
Gemfile:
  required:
    ':system_tests':
      - gem: 'puppet-module-posix-system-r#{minor_version}'
        platforms: ruby
      - gem: 'puppet-module-win-system-r#{minor_version}'
        platforms:
          - mswin
          - mingw
          - x64_mingw
      - gem: beaker
        version: '~> 3.13'
        from_env: BEAKER_VERSION
      - gem: beaker-abs
        from_env: BEAKER_ABS_VERSION
        version: '~> 0.1'
      - gem: beaker-pe
      - gem: beaker-hostgenerator
        from_env: BEAKER_HOSTGENERATOR_VERSION
      - gem: beaker-rspec
        from_env: BEAKER_RSPEC_VERSION
.travis.yml:
  bundler_args: --with system_tests
.gitlab-ci.yml:
  bundler_args: --with system_tests --path vendor/bundle --jobs $(nproc)
  beaker: true
appveyor.yml:
  appveyor_bundle_install: "bundle install --jobs 4 --retry 2 --with system_tests"
```

## Further Notes <a name="notes"></a>

Please note that the early version of this template contained only a 'moduleroot' directory, and did not have a 'moduleroot\_init'. The PDK 'pdk new module' command will still work with templates that only have 'moduleroot', however the 'pdk convert' command will fail if the template does not have a 'moduleroot_init' directory present. To remedy this please use the up to date version of the template.
