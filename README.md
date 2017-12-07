# PDK Templates

The PDK Templates is the default templates repository for use with the [Puppet Development Kit](https://github.com/puppetlabs/pdk), within which we have defined all the templates for the creation and configuration of a module. Look into these directories to find the templates:
* `moduleroot` templates get deployed on `new module` and `convert`; use them to enforce a common boilerplate for central files.
* `moduleroot\_init` templates get only deployed when the target file does not yet exist; use them to provide skeletons for files the developer needs to modify heavily.
* `object_templates` templates are used by the various `new ...` commands for classes, defined types, etc.

The PDK also absorbs the config\_defaults.yml file to apply a set of default configurations to the module.

* [Basic usage](#basic-usage)
* [Config_default Values](#values)
* [Further Notes](#notes)

## Basic Usage

Templates like this one can be used in conjunction with the PDK. As default the PDK itself uses the templates within this repository to render files for use within a module. Templates can be passed to the PDK as a flag for several of the commands.

> pdk convert --template_url https://github.com/puppetlabs/pdk-templates

Please note that the template only needs to be passed in once if you wish to change it, every command run on the PDK will use the last specified template.
For more on basic usage and more detailed description of the PDK in action please refer to the [PDK documentation](https://github.com/puppetlabs/pdk/blob/master/README.md).

## Config_default Values <a name="values"></a>

The following is a description and explaination of each of the keys within config\_defaults. This will help clarify the default settings we choose to apply to pdk modules.

### .gitattributes

>A .gitattributes file in your repo allows you to ensure consistent git settings.

| Key               | Description   |
| :-----------------|:--------------|
| include           | Defines which extensions are handled by git automatic conversions (see the [gitattributes](https://git-scm.com/docs/gitattributes) documentation). The default configuration helps to keep line endings consistent between windows and linux users.|

### .travis.yml

>[Travis CI](https://travis-ci.org/) is a hosted continuous integration platform that is free for all open source projects hosted on Github.
We can trigger automated builds with every change to our code base in the master branch, other branches or even a pull request.
Travis uses a .travis.yml file in the root of your repository to learn about your project and how you want your builds to be executed.

| Key            | Description   |
| :------------- |:--------------|
| ruby versions  |Define the ruby versions on which you want your builds to be executed.|
| bunder\_args   |Define any arguments you want to pass through to bundler. The default is ```--without system_tests``` which avoids installing unnessesary gems.|
| env            |Allows you to set any environment variables for the travis build. Currently includes setting the Puppet gem version alongside the variable ```CHECK``` which determines what tests to run.|
|docker_sets     |Allows you to configure sets of docker to run your tests on. For example, if I wanted to run on a docker instance of Ubuntu I would add  ```set: docker/ubuntu-14.04``` to my docker\_sets attribute.|
|docker_defaults |Defines what values are used as default when using the ```docker_sets``` definition. Includes ruby version, sudo being enabled, the distro, the services, the env variables and the script to execute.|
|includes        |Ensures that the .travis file includes the following checks by default: Rubocop, Puppet Lint, Metadata Lint.|


### appveyor.yml

>[AppVeyor](https://www.appveyor.com/) is a hosted, distributed continuous integration service used to build and test projects hosted on GitHub by spinning up a Microsoft Windows virtual machine. AppVeyor is configured by adding a file named appveyor.yml, which is a YAML format text file, to the root directory of the code repository.

| Key            | Description   |
| :------------- |:--------------|
|appveyor\_bundle\_install|Defines the bundle install command for the appveyor execution run. In our case we use bundle install ```--without system_tests``` as default, therefore avoiding redundant gem installation.|
|environment|Defines any environment variables wanted for the job run. In our case we default to the latest Puppet 4 gem version.|
|matrix|This defines the matrix of jobs to be executed at runtime. Each defines environment variables for that specific job run. In our defaults we have a Ruby version specfied, followed by the check that will be run for that job.|
|test\_script|This defines the test script that will be executed. For our purposes the default is set to ```bundle exec rake %CHECK%```. As appveyor iterates through the test matrix as we defined above, it resolves the variable CHECK and runs the resulting command. For example, our last test script would be executed as ```bundle exec rake spec```, which would run the spec tests of the module.|

### Rakefile

>[Rake](https://github.com/ruby/rake) is a Make-like program implemented in Ruby. Tasks and dependencies are specified in standard Ruby syntax within the Rakefile, present in the root directory of the code repository. Within modules context Rake tasks are used quite frequently, from ensuring the integrity of a module, running validation and tests, to tasks for releasing modules.

| Key            | Description   |
| :------------- |:--------------|
|default\_disabled\_lint\_checks| Defines any checks that are to be disabled by default when running lint checks. As default we disable the ```--relative``` lint check, which compares the module layout relative to the module root. |

### .rubocop.yml

>[RuboCop](https://github.com/bbatsov/rubocop) is a Ruby static code analyzer. We use Rubocop to enforce a level of quility and consistancy within Ruby code. Rubocop can be configured within .rubocop.yml which is located in the root directory of the code repository. Rubocop works by defining a sanitized list of cops that'll cleanup a code base without much effort, all of which support autocorrect and that are fairly uncontroversial across wide segments of the Community.

| Key            | Description   |
| :------------- |:--------------|
|selected\_profile|Allows you to define which profile is used by default, which is set to ```strict```, which is fully defined within the ```profiles``` section.|
|default\_configs |Allows you to define the default configuration of which cops will run. Includes the full name of the cop followed by a description of it and an enforced style. Can also make use of the key ```excludes``` to exclude any files from that specific cop.|
|cleanup\_cops    |Defines a set of cleanup cops to then be included within a rubocop profile. Cops are defined by their full name, and further configuration can be done by specifying secondary keys. By default we specify a large amount of cleanup cops using their default configuration.|
|profiles         |Defines the profiles that can be enabled and used within rubocop through the ```selected_profile``` option. By default we have set up three profiles: cleanups\_only, strict, hardcore and off.|


### Gemfile

>A Gemfile is a file we create which is used for describing gem dependencies for Ruby programs. All modules should have an associated Gemfile for installing the relevant gems. As development and testing is somewhat consistant between modules we have used the template to define a set of gems relevant to these processes.

| Key            | Description   |
| :------------- |:--------------|
|required|Allows you to specify gems that are required within the Gemfile. Gems can be defined here within groups, for example we use the :development gem group to add in several gems that are relevant to the development of any module.|

## Further Notes <a name="notes"></a>

Please note that the early version of this template contained only a 'moduleroot' directory, and did not have a 'moduleroot\_init'. The PDK 'pdk new module' command will still work with templates that only have 'moduleroot', however the 'pdk convert' command will fail if the template does not have a 'moduleroot_init' directory present. To remedy this please use the up to date version of the template.
