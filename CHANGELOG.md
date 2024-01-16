<!-- markdownlint-disable MD024 -->
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](http://semver.org).

## [3.0.1](https://github.com/puppetlabs/pdk-templates/tree/3.0.1) - 2023-12-12

[Full Changelog](https://github.com/puppetlabs/pdk-templates/compare/3.0.0...3.0.1)

### Added

- (CAT-1606) - Adding gem group for release_pre [#540](https://github.com/puppetlabs/pdk-templates/pull/540) ([Ramesh7](https://github.com/Ramesh7))
- Allow puppet-lint fail_on_warnings to be disabled [#515](https://github.com/puppetlabs/pdk-templates/pull/515) ([nabertrand](https://github.com/nabertrand))

### Fixed

- (CAT-1612) Revert removal of puppetlabs_spec_helper and puppet-string changes [#546](https://github.com/puppetlabs/pdk-templates/pull/546) ([david22swan](https://github.com/david22swan))

## [3.0.0](https://github.com/puppetlabs/pdk-templates/tree/3.0.0) - 2023-08-16

[Full Changelog](https://github.com/puppetlabs/pdk-templates/compare/2.7.5...3.0.0)

### Changed
- (CONT-885) pdk-templates v3 prep [#510](https://github.com/puppetlabs/pdk-templates/pull/510) ([chelnak](https://github.com/chelnak))

### Added

- (CONT-1229) - Allow nested extra networking facts [#529](https://github.com/puppetlabs/pdk-templates/pull/529) ([jordanbreen28](https://github.com/jordanbreen28))
- (CONT-1119) Add puppet-strings [#522](https://github.com/puppetlabs/pdk-templates/pull/522) ([chelnak](https://github.com/chelnak))
- Enable puppet coverage reports [#465](https://github.com/puppetlabs/pdk-templates/pull/465) ([bastelfreak](https://github.com/bastelfreak))

### Fixed

- (MAINT) Fix incorrect requirement for racc [#520](https://github.com/puppetlabs/pdk-templates/pull/520) ([chelnak](https://github.com/chelnak))
- (MAINT) Pin racc for Ruby 2.7 [#519](https://github.com/puppetlabs/pdk-templates/pull/519) ([chelnak](https://github.com/chelnak))
- Update Rakefile gem detection method [#518](https://github.com/puppetlabs/pdk-templates/pull/518) ([nabertrand](https://github.com/nabertrand))
- (maint) - Update fixtures/modules path for .gitignore [#517](https://github.com/puppetlabs/pdk-templates/pull/517) ([jordanbreen28](https://github.com/jordanbreen28))
- (MAINT) Fix YAML.safe_load [#512](https://github.com/puppetlabs/pdk-templates/pull/512) ([chelnak](https://github.com/chelnak))
- Add missing quotes around facter_implementation [#508](https://github.com/puppetlabs/pdk-templates/pull/508) ([ardrigh](https://github.com/ardrigh))

## [2.7.5](https://github.com/puppetlabs/pdk-templates/tree/2.7.5) - 2023-04-22

[Full Changelog](https://github.com/puppetlabs/pdk-templates/compare/2.7.4...2.7.5)

### Fixed

- Remove puppet-blacksmith requirement [#507](https://github.com/puppetlabs/pdk-templates/pull/507) ([MartyEwings](https://github.com/MartyEwings))

## [2.7.4](https://github.com/puppetlabs/pdk-templates/tree/2.7.4) - 2023-03-20

[Full Changelog](https://github.com/puppetlabs/pdk-templates/compare/2.7.3...2.7.4)

### Fixed

- (GH-501) Remove legacy facts gem [#502](https://github.com/puppetlabs/pdk-templates/pull/502) ([chelnak](https://github.com/chelnak))

## [2.7.3](https://github.com/puppetlabs/pdk-templates/tree/2.7.3) - 2023-03-09

[Full Changelog](https://github.com/puppetlabs/pdk-templates/compare/2.7.2...2.7.3)

### Added

- Add support for GitLab Code Quality reports [#499](https://github.com/puppetlabs/pdk-templates/pull/499) ([alexjfisher](https://github.com/alexjfisher))

### Fixed

- (CONT-705) Pin parallel_tests gem [#500](https://github.com/puppetlabs/pdk-templates/pull/500) ([chelnak](https://github.com/chelnak))

## [2.7.2](https://github.com/puppetlabs/pdk-templates/tree/2.7.2) - 2023-03-01

[Full Changelog](https://github.com/puppetlabs/pdk-templates/compare/2.7.1...2.7.2)

### Added

- Add x64_mingw support for puppet_litmus [#497](https://github.com/puppetlabs/pdk-templates/pull/497) ([chelnak](https://github.com/chelnak))
- (maint) Updates checkout action [#494](https://github.com/puppetlabs/pdk-templates/pull/494) ([mhashizume](https://github.com/mhashizume))
- allow to configure rspec-puppet's facter_implementation [#473](https://github.com/puppetlabs/pdk-templates/pull/473) ([skoef](https://github.com/skoef))

### Fixed

- Ensure that the devcontainer.json is valid JSON [#490](https://github.com/puppetlabs/pdk-templates/pull/490) ([zigsphere](https://github.com/zigsphere))

## [2.7.1](https://github.com/puppetlabs/pdk-templates/tree/2.7.1) - 2023-01-16

[Full Changelog](https://github.com/puppetlabs/pdk-templates/compare/2.7.0...2.7.1)

### Fixed

- (MAINT) Replacing json with json_pure [#486](https://github.com/puppetlabs/pdk-templates/pull/486) ([pmcmaw](https://github.com/pmcmaw))
- voxpupuli-puppet-lint-plugins: Pull in 3.1 or newer [#484](https://github.com/puppetlabs/pdk-templates/pull/484) ([bastelfreak](https://github.com/bastelfreak))

## [2.7.0](https://github.com/puppetlabs/pdk-templates/tree/2.7.0) - 2022-11-23

[Full Changelog](https://github.com/puppetlabs/pdk-templates/compare/2.6.0...2.7.0)

### Added

- Enhance class_spec.rb file [#482](https://github.com/puppetlabs/pdk-templates/pull/482) ([bastelfreak](https://github.com/bastelfreak))
- (CONT-19) Removal of puppet-module-gems [#481](https://github.com/puppetlabs/pdk-templates/pull/481) ([david22swan](https://github.com/david22swan))

### Fixed

- (maint) Exclusion added against Json version [#483](https://github.com/puppetlabs/pdk-templates/pull/483) ([david22swan](https://github.com/david22swan))

## [2.6.0](https://github.com/puppetlabs/pdk-templates/tree/2.6.0) - 2022-10-05

[Full Changelog](https://github.com/puppetlabs/pdk-templates/compare/2.5.0...2.6.0)

### Added

- (CONT-19) Removal of puppet-module-gems [#481](https://github.com/puppetlabs/pdk-templates/pull/481) ([david22swan](https://github.com/david22swan))
- Adds documentation for testing and mocking facts [#474](https://github.com/puppetlabs/pdk-templates/pull/474) ([logicminds](https://github.com/logicminds))

## [2.5.0](https://github.com/puppetlabs/pdk-templates/tree/2.5.0) - 2022-05-18

[Full Changelog](https://github.com/puppetlabs/pdk-templates/compare/2.4.0...2.5.0)

### Added

- (packaging) Enable puppet-lint-plugins also on Windows #468 [#469](https://github.com/puppetlabs/pdk-templates/pull/469) ([ConradGroth](https://github.com/ConradGroth))
- Use voxpupuli-puppet-lint-plugins [#463](https://github.com/puppetlabs/pdk-templates/pull/463) ([bastelfreak](https://github.com/bastelfreak))

### Fixed

- Update TargetrubyVersion for rubocop [#466](https://github.com/puppetlabs/pdk-templates/pull/466) ([MartyEwings](https://github.com/MartyEwings))

## [2.4.0](https://github.com/puppetlabs/pdk-templates/tree/2.4.0) - 2022-02-07

[Full Changelog](https://github.com/puppetlabs/pdk-templates/compare/2.3.0...2.4.0)

### Added

- Add a knob to allow tasks testing using ruby_task_helper [#461](https://github.com/puppetlabs/pdk-templates/pull/461) ([smortex](https://github.com/smortex))

### Fixed

- (MODULES-11220) Disable nightly workflows on forks [#458](https://github.com/puppetlabs/pdk-templates/pull/458) ([sanfrancrisko](https://github.com/sanfrancrisko))

## [2.3.0](https://github.com/puppetlabs/pdk-templates/tree/2.3.0) - 2021-10-21

[Full Changelog](https://github.com/puppetlabs/pdk-templates/compare/2.2.0...2.3.0)

### Added

- (GH-449) Adds `enabled` flag for honeycomb [#455](https://github.com/puppetlabs/pdk-templates/pull/455) ([da-ar](https://github.com/da-ar))
- [IAC-1738] - exclude platforms from GA matrixes [#454](https://github.com/puppetlabs/pdk-templates/pull/454) ([adrianiurca](https://github.com/adrianiurca))
- Add support for puppet-lint ignore-paths  [#450](https://github.com/puppetlabs/pdk-templates/pull/450) ([da-ar](https://github.com/da-ar))
- Only auto release if the changelog is updated [#443](https://github.com/puppetlabs/pdk-templates/pull/443) ([jarretlavallee](https://github.com/jarretlavallee))

### Fixed

- (GH-445,456) devcontainer updates [#457](https://github.com/puppetlabs/pdk-templates/pull/457) ([da-ar](https://github.com/da-ar))
- (GH-327) Fix rubocop "off" & "hardcore" profiles [#453](https://github.com/puppetlabs/pdk-templates/pull/453) ([russellshackleford](https://github.com/russellshackleford))
- Remove env from GitHub template if all sub-keys are unset [#451](https://github.com/puppetlabs/pdk-templates/pull/451) ([thebeanogamer](https://github.com/thebeanogamer))
- Don't append a tag to image name if one already exists [#446](https://github.com/puppetlabs/pdk-templates/pull/446) ([silug](https://github.com/silug))

## [2.2.0](https://github.com/puppetlabs/pdk-templates/tree/2.2.0) - 2021-08-02

[Full Changelog](https://github.com/puppetlabs/pdk-templates/compare/2.1.1...2.2.0)

### Added

- Set `skip_branch_with_pr` to true by default in appveyor.yml template [#442](https://github.com/puppetlabs/pdk-templates/pull/442) ([TraGicCode](https://github.com/TraGicCode))
- Run validation steps prior to the matrix build [#441](https://github.com/puppetlabs/pdk-templates/pull/441) ([ekohl](https://github.com/ekohl))
- Use latest facter gem in spec tests [#439](https://github.com/puppetlabs/pdk-templates/pull/439) ([carabasdaniel](https://github.com/carabasdaniel))

## [2.1.1](https://github.com/puppetlabs/pdk-templates/tree/2.1.1) - 2021-06-07

[Full Changelog](https://github.com/puppetlabs/pdk-templates/compare/2.1.0...2.1.1)

### Added

- Use latest facter gem in spec tests [#439](https://github.com/puppetlabs/pdk-templates/pull/439) ([carabasdaniel](https://github.com/carabasdaniel))
- Allow auto_release workflow schedule configuration [#438](https://github.com/puppetlabs/pdk-templates/pull/438) ([carabasdaniel](https://github.com/carabasdaniel))
- added more fine-grained control of custom_before_steps [#436](https://github.com/puppetlabs/pdk-templates/pull/436) ([skoef](https://github.com/skoef))
- added tags to .gitlab-ci.yml.erb [#434](https://github.com/puppetlabs/pdk-templates/pull/434) ([skoef](https://github.com/skoef))
- Add changelog_max_issues configuration [#433](https://github.com/puppetlabs/pdk-templates/pull/433) ([carabasdaniel](https://github.com/carabasdaniel))
- Cleanup backtrace in spec tests [#431](https://github.com/puppetlabs/pdk-templates/pull/431) ([DavidS](https://github.com/DavidS))
- Misc cleanup [#429](https://github.com/puppetlabs/pdk-templates/pull/429) ([jeffbyrnes](https://github.com/jeffbyrnes))
- Add EditorConfig [#428](https://github.com/puppetlabs/pdk-templates/pull/428) ([jeffbyrnes](https://github.com/jeffbyrnes))
- git ignore spec/fixtures/litmus_inventory.yaml [#426](https://github.com/puppetlabs/pdk-templates/pull/426) ([adrianiurca](https://github.com/adrianiurca))

### Fixed

- Fix Bug in .rubocop.yml.erb [#432](https://github.com/puppetlabs/pdk-templates/pull/432) ([cocker-cc](https://github.com/cocker-cc))
- (maint) Update Gitpod to Puppet VSCode Extension to 1.2.0 [#423](https://github.com/puppetlabs/pdk-templates/pull/423) ([jpogran](https://github.com/jpogran))

## [2.1.0](https://github.com/puppetlabs/pdk-templates/tree/2.1.0) - 2021-03-31

[Full Changelog](https://github.com/puppetlabs/pdk-templates/compare/2.0.0...2.1.0)

### Added

- (GH-380) Relocation of inventory.yaml file [#414](https://github.com/puppetlabs/pdk-templates/pull/414) ([pmcmaw](https://github.com/pmcmaw))
- Add manual module publish and tag workflow using FORGE_API_KEY secret [#408](https://github.com/puppetlabs/pdk-templates/pull/408) ([carabasdaniel](https://github.com/carabasdaniel))
- Use different providers in Github Action workflows matrix [#398](https://github.com/puppetlabs/pdk-templates/pull/398) ([carabasdaniel](https://github.com/carabasdaniel))
- (IAC-1307) Add Spec tests to nightly and pr_test GHActions configs [#372](https://github.com/puppetlabs/pdk-templates/pull/372) ([sanfrancrisko](https://github.com/sanfrancrisko))

### Fixed

- Add static & syntax checks to spec workflow [#417](https://github.com/puppetlabs/pdk-templates/pull/417) ([sanfrancrisko](https://github.com/sanfrancrisko))
- (#412) Add .devcontainer to .pdkignore [#413](https://github.com/puppetlabs/pdk-templates/pull/413) ([silug](https://github.com/silug))
- Add Puppet 7 tests to .gitlab-ci.yml [#411](https://github.com/puppetlabs/pdk-templates/pull/411) ([silug](https://github.com/silug))

## [2.0.0](https://github.com/puppetlabs/pdk-templates/tree/2.0.0) - 2021-02-24

[Full Changelog](https://github.com/puppetlabs/pdk-templates/compare/1.18.1...2.0.0)

### Changed
- Remove puppet5 from gitlab-ci defaults [#407](https://github.com/puppetlabs/pdk-templates/pull/407) ([carabasdaniel](https://github.com/carabasdaniel))
- (MAINT) Remove puppet-module-system gems for older Puppet versions [#386](https://github.com/puppetlabs/pdk-templates/pull/386) ([scotje](https://github.com/scotje))

### Added

- Set auto_release.yml as unmanaged in default configs [#406](https://github.com/puppetlabs/pdk-templates/pull/406) ([carabasdaniel](https://github.com/carabasdaniel))
- Use rspec-mocks as default mocking library [#404](https://github.com/puppetlabs/pdk-templates/pull/404) ([DavidS](https://github.com/DavidS))
- Remove puppet5 from config_defaults.yml [#403](https://github.com/puppetlabs/pdk-templates/pull/403) ([carabasdaniel](https://github.com/carabasdaniel))
- Don't enforce frozen string comments [#402](https://github.com/puppetlabs/pdk-templates/pull/402) ([DavidS](https://github.com/DavidS))
- Finalise auto-release-prep using pdk-docker image and cleanup artifacts [#395](https://github.com/puppetlabs/pdk-templates/pull/395) ([carabasdaniel](https://github.com/carabasdaniel))
- Add automatic release preparation workflow [#393](https://github.com/puppetlabs/pdk-templates/pull/393) ([carabasdaniel](https://github.com/carabasdaniel))
- Fix handling of `pending` cops; configure some egregious cops [#383](https://github.com/puppetlabs/pdk-templates/pull/383) ([DavidS](https://github.com/DavidS))
- Use ruby/setup-ruby Github action [#382](https://github.com/puppetlabs/pdk-templates/pull/382) ([ekohl](https://github.com/ekohl))
- Add object templates for functions [#379](https://github.com/puppetlabs/pdk-templates/pull/379) ([logicminds](https://github.com/logicminds))
- Update how we handle at-risk action sources [#377](https://github.com/puppetlabs/pdk-templates/pull/377) ([DavidS](https://github.com/DavidS))
- Remove Layout/HashAlignment from the default cleanup cops [#375](https://github.com/puppetlabs/pdk-templates/pull/375) ([DavidS](https://github.com/DavidS))
- Updates for ruby 2.4 and rubocop 1.6.1 [#371](https://github.com/puppetlabs/pdk-templates/pull/371) ([DavidS](https://github.com/DavidS))
- Allow to use a different dist per collection [#366](https://github.com/puppetlabs/pdk-templates/pull/366) ([adrianiurca](https://github.com/adrianiurca))
- Update honeycomb buildevents tracking [#365](https://github.com/puppetlabs/pdk-templates/pull/365) ([DavidS](https://github.com/DavidS))
- Add github workflows with puppetlabs defaults for the provision_service [#363](https://github.com/puppetlabs/pdk-templates/pull/363) ([DavidS](https://github.com/DavidS))
- Add object templates for generating new facts [#361](https://github.com/puppetlabs/pdk-templates/pull/361) ([logicminds](https://github.com/logicminds))
- (#353) Add an empty, commented .sync.yml [#356](https://github.com/puppetlabs/pdk-templates/pull/356) ([silug](https://github.com/silug))
- Add gitpod support for puppet modules [#354](https://github.com/puppetlabs/pdk-templates/pull/354) ([logicminds](https://github.com/logicminds))
- (IAC-1026) - Update default travis/appveyor branches from master to main [#343](https://github.com/puppetlabs/pdk-templates/pull/343) ([david22swan](https://github.com/david22swan))
- (IAC-940) Add a remove_includes configuration option [#342](https://github.com/puppetlabs/pdk-templates/pull/342) ([sheenaajay](https://github.com/sheenaajay))
- Add optional litmus config to gitlab-ci [#338](https://github.com/puppetlabs/pdk-templates/pull/338) ([cdenneen](https://github.com/cdenneen))
- Change global_variables key for GitLab CI to set defaults that can be overridden by jobs [#332](https://github.com/puppetlabs/pdk-templates/pull/332) ([cdenneen](https://github.com/cdenneen))

### Fixed

- Re-add ClassAndModuleCamelCase disabling on transport_device [#405](https://github.com/puppetlabs/pdk-templates/pull/405) ([DavidS](https://github.com/DavidS))
- (#397) Address some validation issues in object_templates [#401](https://github.com/puppetlabs/pdk-templates/pull/401) ([DavidS](https://github.com/DavidS))
- gitlab-ci: unbreak litmus acceptance tests [#400](https://github.com/puppetlabs/pdk-templates/pull/400) ([cdenneen](https://github.com/cdenneen))
- gitlab-ci: make litmus[variables] optional [#399](https://github.com/puppetlabs/pdk-templates/pull/399) ([cdenneen](https://github.com/cdenneen))
- Update Github Actions auto_release workflow [#394](https://github.com/puppetlabs/pdk-templates/pull/394) ([carabasdaniel](https://github.com/carabasdaniel))
- Revert litmus protection [#392](https://github.com/puppetlabs/pdk-templates/pull/392) ([DavidS](https://github.com/DavidS))
- Add bundler require to Rakefile [#390](https://github.com/puppetlabs/pdk-templates/pull/390) ([DavidS](https://github.com/DavidS))
- (FIX) Ensure system PMG gem installed when PUPPET_GEM_VERSION nil [#389](https://github.com/puppetlabs/pdk-templates/pull/389) ([sanfrancrisko](https://github.com/sanfrancrisko))
- (MAINT) Fix bundler resolution issues for older puppet versions [#385](https://github.com/puppetlabs/pdk-templates/pull/385) ([scotje](https://github.com/scotje))
- (maint) Fix GitHub acceptance test setup when not common owner [#378](https://github.com/puppetlabs/pdk-templates/pull/378) ([jarretlavallee](https://github.com/jarretlavallee))
- Fix Include syntax for new rubocop [#374](https://github.com/puppetlabs/pdk-templates/pull/374) ([DavidS](https://github.com/DavidS))
- (SEC-250) Pin non-github provided actions to a specific SHA [#370](https://github.com/puppetlabs/pdk-templates/pull/370) ([DavidS](https://github.com/DavidS))
- github actions: Don't retry at the workflow level [#367](https://github.com/puppetlabs/pdk-templates/pull/367) ([DavidS](https://github.com/DavidS))
- Avoid second failure if provision doesn't create inventory [#364](https://github.com/puppetlabs/pdk-templates/pull/364) ([DavidS](https://github.com/DavidS))
- Update to newest puppet-vscode extension [#362](https://github.com/puppetlabs/pdk-templates/pull/362) ([DavidS](https://github.com/DavidS))
- (fix) Set rubocop ruby version to 2.4 [#360](https://github.com/puppetlabs/pdk-templates/pull/360) ([tuxmea](https://github.com/tuxmea))
- (MAINT) Add `json` pin for Ruby 2.7.x [#358](https://github.com/puppetlabs/pdk-templates/pull/358) ([scotje](https://github.com/scotje))
- (#352) Add .puppet-lint.rc and .sync.yml to .pdkignore [#355](https://github.com/puppetlabs/pdk-templates/pull/355) ([silug](https://github.com/silug))
- (#350) Update deprecated globals [#351](https://github.com/puppetlabs/pdk-templates/pull/351) ([silug](https://github.com/silug))
- (#348) Add .devcontainer for vscode [#349](https://github.com/puppetlabs/pdk-templates/pull/349) ([silug](https://github.com/silug))
- Fix disabling of BracesAroundHashParameters [#344](https://github.com/puppetlabs/pdk-templates/pull/344) ([alexjfisher](https://github.com/alexjfisher))
- Conditional can't be used with false. Since default is true it is not needed [#337](https://github.com/puppetlabs/pdk-templates/pull/337) ([cdenneen](https://github.com/cdenneen))

## [1.18.1](https://github.com/puppetlabs/pdk-templates/tree/1.18.1) - 2020-07-16

[Full Changelog](https://github.com/puppetlabs/pdk-templates/compare/1.18.0...1.18.1)

### Added

- Update changelog generation: default github labels and new upstream [#333](https://github.com/puppetlabs/pdk-templates/pull/333) ([DavidS](https://github.com/DavidS))
- (IAC-805) add configuration option for more complex litmus matrices to travis [#331](https://github.com/puppetlabs/pdk-templates/pull/331) ([david22swan](https://github.com/david22swan))

### Fixed

- (maint) Ensure wget install succeeds on RHEL OSs [#340](https://github.com/puppetlabs/pdk-templates/pull/340) ([sanfrancrisko](https://github.com/sanfrancrisko))
- use --targets instead of --nodes for bolt command [#336](https://github.com/puppetlabs/pdk-templates/pull/336) ([TheMeier](https://github.com/TheMeier))

## [1.18.0](https://github.com/puppetlabs/pdk-templates/tree/1.18.0) - 2020-05-12

[Full Changelog](https://github.com/puppetlabs/pdk-templates/compare/1.17.0...1.18.0)

### Added

- Added strict_variables config setting [#326](https://github.com/puppetlabs/pdk-templates/pull/326) ([cdenneen](https://github.com/cdenneen))
- (PDK-1591) Add option to enable legacy_facts puppet-lint plugin [#320](https://github.com/puppetlabs/pdk-templates/pull/320) ([rodjek](https://github.com/rodjek))

### Fixed

- Disable RuboCop Style/BracesAroundHashParameters [#329](https://github.com/puppetlabs/pdk-templates/pull/329) ([Sharpie](https://github.com/Sharpie))
- (maint) Update Puppet VS Code Extension publisher [#323](https://github.com/puppetlabs/pdk-templates/pull/323) ([jpogran](https://github.com/jpogran))
- (MAINT) Fix documentation link in README template [#322](https://github.com/puppetlabs/pdk-templates/pull/322) ([geoffnichols](https://github.com/geoffnichols))
- (PDK-1633) Update common.yaml [#321](https://github.com/puppetlabs/pdk-templates/pull/321) ([glennsarti](https://github.com/glennsarti))

## [1.17.0](https://github.com/puppetlabs/pdk-templates/tree/1.17.0) - 2020-02-27

[Full Changelog](https://github.com/puppetlabs/pdk-templates/compare/1.16.0...1.17.0)

### Added

- Update to latest ruby version supported by the agent [#318](https://github.com/puppetlabs/pdk-templates/pull/318) ([DavidS](https://github.com/DavidS))
- Add `default_facter_version` parameter to `.sync.yml` [#311](https://github.com/puppetlabs/pdk-templates/pull/311) ([rnelson0](https://github.com/rnelson0))

### Fixed

- (IAC-554) Use travis_wait to avoid livelock; update tavis runner version; whitespace fixes [#319](https://github.com/puppetlabs/pdk-templates/pull/319) ([DavidS](https://github.com/DavidS))
- (PDK-1609) Prefer os.name over os.family in hiera.yaml [#316](https://github.com/puppetlabs/pdk-templates/pull/316) ([rodjek](https://github.com/rodjek))
- Updated for GitLab Advanced except/only ability [#314](https://github.com/puppetlabs/pdk-templates/pull/314) ([cdenneen](https://github.com/cdenneen))
- resolve some Travis-CI build config validation issues [#312](https://github.com/puppetlabs/pdk-templates/pull/312) ([rtib](https://github.com/rtib))

## [1.16.0](https://github.com/puppetlabs/pdk-templates/tree/1.16.0) - 2020-02-05

[Full Changelog](https://github.com/puppetlabs/pdk-templates/compare/1.15.0...1.16.0)

### Added

- Update puppet-module gems to current version [#291](https://github.com/puppetlabs/pdk-templates/pull/291) ([DavidS](https://github.com/DavidS))

### Fixed

- Change NetworkDevice module to class [#302](https://github.com/puppetlabs/pdk-templates/pull/302) ([DavidS](https://github.com/DavidS))
- Update travis and gitlab to run `gem update --system` only when requested [#300](https://github.com/puppetlabs/pdk-templates/pull/300) ([DavidS](https://github.com/DavidS))

### Other

- (#292) Document the 'required' parameter for .gitignore and .pdkignore templates [#313](https://github.com/puppetlabs/pdk-templates/pull/313) ([rodjek](https://github.com/rodjek))
- Added Gitlab CI Basic only/except options  [#310](https://github.com/puppetlabs/pdk-templates/pull/310) ([cdenneen](https://github.com/cdenneen))
- Changes for github_changelog_generator Raketask [#309](https://github.com/puppetlabs/pdk-templates/pull/309) ([cdenneen](https://github.com/cdenneen))
- Add header to *.rb files to be ruby 2.4+ compatible [#306](https://github.com/puppetlabs/pdk-templates/pull/306) ([Felixoid](https://github.com/Felixoid))
- Fix rubygems update in runners with pipefail set [#305](https://github.com/puppetlabs/pdk-templates/pull/305) ([lusor](https://github.com/lusor))
- (maint) Fix non-interactive rubygems update [#303](https://github.com/puppetlabs/pdk-templates/pull/303) ([rodjek](https://github.com/rodjek))
- FM-8769 - add use_litmus to configure to use Litmus for acceptance testing jobs [#296](https://github.com/puppetlabs/pdk-templates/pull/296) ([lionce](https://github.com/lionce))

## [1.15.0](https://github.com/puppetlabs/pdk-templates/tree/1.15.0) - 2019-12-13

[Full Changelog](https://github.com/puppetlabs/pdk-templates/compare/1.14.1...1.15.0)

### Added

- Support setting `os` and `install` keys for appveyor and travis [#293](https://github.com/puppetlabs/pdk-templates/pull/293) ([DavidS](https://github.com/DavidS))

### Other

- Boolean to remove the before_script section in .gitlab-ci.yml [#299](https://github.com/puppetlabs/pdk-templates/pull/299) ([rodjek](https://github.com/rodjek))
- (#290) Do not manually generate YAML in .gitlab-ci.yml [#298](https://github.com/puppetlabs/pdk-templates/pull/298) ([rodjek](https://github.com/rodjek))
- (maint) Make module deployment in Travis opt-out [#289](https://github.com/puppetlabs/pdk-templates/pull/289) ([glennsarti](https://github.com/glennsarti))
- (PDK-1500) Update Litmus configuration in Appveyor [#288](https://github.com/puppetlabs/pdk-templates/pull/288) ([glennsarti](https://github.com/glennsarti))
- (PDK-1500) Update Appveyor and Gemfile templates for Litmus [#287](https://github.com/puppetlabs/pdk-templates/pull/287) ([glennsarti](https://github.com/glennsarti))

## [1.14.1](https://github.com/puppetlabs/pdk-templates/tree/1.14.1) - 2019-11-01

[Full Changelog](https://github.com/puppetlabs/pdk-templates/compare/1.14.0...1.14.1)

### Other

- (#283) Unwrap password in transport object template [#286](https://github.com/puppetlabs/pdk-templates/pull/286) ([rodjek](https://github.com/rodjek))
- Ignore *~ files [#285](https://github.com/puppetlabs/pdk-templates/pull/285) ([freiheit](https://github.com/freiheit))

## [1.14.0](https://github.com/puppetlabs/pdk-templates/tree/1.14.0) - 2019-10-09

[Full Changelog](https://github.com/puppetlabs/pdk-templates/compare/1.13.0...1.14.0)

### Other

- (PDK-1439) Ignore GetText rubocop rules for the off profile [#280](https://github.com/puppetlabs/pdk-templates/pull/280) ([glennsarti](https://github.com/glennsarti))
- (maint) Add default ipaddress6 fact [#278](https://github.com/puppetlabs/pdk-templates/pull/278) ([rodjek](https://github.com/rodjek))
- (maint) Add CODEOWNERS [#277](https://github.com/puppetlabs/pdk-templates/pull/277) ([glennsarti](https://github.com/glennsarti))
- Fix GitLab CI empty custom job parameter handling [#276](https://github.com/puppetlabs/pdk-templates/pull/276) ([seanmil](https://github.com/seanmil))

## [1.13.0](https://github.com/puppetlabs/pdk-templates/tree/1.13.0) - 2019-08-29

[Full Changelog](https://github.com/puppetlabs/pdk-templates/compare/1.12.0...1.13.0)

### Fixed

- (PDK-1461) changelog_project fixes [#272](https://github.com/puppetlabs/pdk-templates/pull/272) ([genebean](https://github.com/genebean))

### Other

- (MAINT) Fix URLs in Travis config for release and nightly repo debs [#275](https://github.com/puppetlabs/pdk-templates/pull/275) ([scotje](https://github.com/scotje))
- (GH-205) Hiera to use better defaults for modules [#206](https://github.com/puppetlabs/pdk-templates/pull/206) ([ghoneycutt](https://github.com/ghoneycutt))

## [1.12.0](https://github.com/puppetlabs/pdk-templates/tree/1.12.0) - 2019-07-31

[Full Changelog](https://github.com/puppetlabs/pdk-templates/compare/1.11.1...1.12.0)

### Other

- (maint) Add rb-readline to Windows gems [#271](https://github.com/puppetlabs/pdk-templates/pull/271) ([rodjek](https://github.com/rodjek))
- (PDK-1417) Allow linter failure on warnings [#265](https://github.com/puppetlabs/pdk-templates/pull/265) ([seanmil](https://github.com/seanmil))
- (PDK-1416) Support Gemfile source option [#262](https://github.com/puppetlabs/pdk-templates/pull/262) ([seanmil](https://github.com/seanmil))
- Override facterdb with default_facts [#257](https://github.com/puppetlabs/pdk-templates/pull/257) ([npwalker](https://github.com/npwalker))

## [1.11.1](https://github.com/puppetlabs/pdk-templates/tree/1.11.1) - 2019-07-01

[Full Changelog](https://github.com/puppetlabs/pdk-templates/compare/1.11.0...1.11.1)

### Other

- Disable PDK analytics in Travis CI [#263](https://github.com/puppetlabs/pdk-templates/pull/263) ([seanmil](https://github.com/seanmil))

## [1.11.0](https://github.com/puppetlabs/pdk-templates/tree/1.11.0) - 2019-06-27

[Full Changelog](https://github.com/puppetlabs/pdk-templates/compare/1.10.0...1.11.0)

### Added

- Addition of before_deploy option [#261](https://github.com/puppetlabs/pdk-templates/pull/261) ([HelenCampbell](https://github.com/HelenCampbell))
- (maint) implement simplecov for appveyor [#252](https://github.com/puppetlabs/pdk-templates/pull/252) ([DavidS](https://github.com/DavidS))
- (PDK-1355) Add hiera_config_ruby to accept ruby snippets [#245](https://github.com/puppetlabs/pdk-templates/pull/245) ([sheenaajay](https://github.com/sheenaajay))

### Other

- (maint) Exclude spec folder for GetText/DecorateString [#259](https://github.com/puppetlabs/pdk-templates/pull/259) ([eimlav](https://github.com/eimlav))
- (FM-7709) include litmus rake tasks if gem exists [#258](https://github.com/puppetlabs/pdk-templates/pull/258) ([tphoney](https://github.com/tphoney))
- (maint) VSCode Recommended Extensions file [#256](https://github.com/puppetlabs/pdk-templates/pull/256) ([jpogran](https://github.com/jpogran))
- (FM-8081) fix up last issues in transport template [#254](https://github.com/puppetlabs/pdk-templates/pull/254) ([DavidS](https://github.com/DavidS))
- (FM-8081) Add DeviceShim template too [#253](https://github.com/puppetlabs/pdk-templates/pull/253) ([DavidS](https://github.com/DavidS))
- (FM-8081) Templates for `pdk new transport` [#251](https://github.com/puppetlabs/pdk-templates/pull/251) ([DavidS](https://github.com/DavidS))
- Support setting puppet collection with docker_sets [#249](https://github.com/puppetlabs/pdk-templates/pull/249) ([treydock](https://github.com/treydock))
- (MAINT) Add minimum version pinning to default puppet-module-* gem deps [#248](https://github.com/puppetlabs/pdk-templates/pull/248) ([scotje](https://github.com/scotje))
- (MAINT) Require rubocop-i18n as part of default rubocop config [#247](https://github.com/puppetlabs/pdk-templates/pull/247) ([scotje](https://github.com/scotje))
- improved README wording [#246](https://github.com/puppetlabs/pdk-templates/pull/246) ([rtib](https://github.com/rtib))
- (MAINT) Ensure .gitlab-ci.yaml configs are merged in the correct order [#244](https://github.com/puppetlabs/pdk-templates/pull/244) ([scotje](https://github.com/scotje))
- Add documentation to satisfy YARD [#243](https://github.com/puppetlabs/pdk-templates/pull/243) ([bjvrielink](https://github.com/bjvrielink))
- (MAINT) --template-ref commit targetting again [#241](https://github.com/puppetlabs/pdk-templates/pull/241) ([scotje](https://github.com/scotje))
- (MAINT) Create test branch from FETCH_HEAD instead of $TRAVIS_COMMIT [#240](https://github.com/puppetlabs/pdk-templates/pull/240) ([scotje](https://github.com/scotje))
- (MAINT) Refactor this repo's travis test script to use --template-ref [#239](https://github.com/puppetlabs/pdk-templates/pull/239) ([scotje](https://github.com/scotje))
- (PDK-1351) Enable custom steps in before_script for GitLab CI [#238](https://github.com/puppetlabs/pdk-templates/pull/238) ([L-Henke](https://github.com/L-Henke))
- (FM-7918) - Update so that appveyor is ran against the release branch [#236](https://github.com/puppetlabs/pdk-templates/pull/236) ([david22swan](https://github.com/david22swan))
- Update travis dist to xenial by default [#235](https://github.com/puppetlabs/pdk-templates/pull/235) ([npwalker](https://github.com/npwalker))
- Read the project name from `source` instead of `name` [#231](https://github.com/puppetlabs/pdk-templates/pull/231) ([rnelson0](https://github.com/rnelson0))
- (GH-223) .travis.yml does not deploy by default [#224](https://github.com/puppetlabs/pdk-templates/pull/224) ([ghoneycutt](https://github.com/ghoneycutt))
- (GH-221) Make .travis.yml's dist attribute configurable [#222](https://github.com/puppetlabs/pdk-templates/pull/222) ([ghoneycutt](https://github.com/ghoneycutt))
- Fix needed settings to enable beaker [#214](https://github.com/puppetlabs/pdk-templates/pull/214) ([TheMeier](https://github.com/TheMeier))
- Remove leading whitespace from README template [#213](https://github.com/puppetlabs/pdk-templates/pull/213) ([montaguethomas](https://github.com/montaguethomas))
- (GH-198) Fix documentation of resource API type [#199](https://github.com/puppetlabs/pdk-templates/pull/199) ([ghoneycutt](https://github.com/ghoneycutt))
- Clarify license when using the templates [#187](https://github.com/puppetlabs/pdk-templates/pull/187) ([DavidS](https://github.com/DavidS))

## [1.10.0](https://github.com/puppetlabs/pdk-templates/tree/1.10.0) - 2019-04-02

[Full Changelog](https://github.com/puppetlabs/pdk-templates/compare/1.9.1...1.10.0)

### Other

- Revert "Add Visual Studio Code to gitignote (.vscode/)" [#228](https://github.com/puppetlabs/pdk-templates/pull/228) ([glennsarti](https://github.com/glennsarti))
- (GH-217) PDK to ignore rakelib directory [#219](https://github.com/puppetlabs/pdk-templates/pull/219) ([ghoneycutt](https://github.com/ghoneycutt))
- (GH-217) Document how to extend Rake using rakelib [#218](https://github.com/puppetlabs/pdk-templates/pull/218) ([ghoneycutt](https://github.com/ghoneycutt))
- (GH-215) Use the correct ruby version for testing Puppet 5 [#216](https://github.com/puppetlabs/pdk-templates/pull/216) ([ghoneycutt](https://github.com/ghoneycutt))
- (FM-7847) adding puppet_litmus defaults [#212](https://github.com/puppetlabs/pdk-templates/pull/212) ([tphoney](https://github.com/tphoney))
- Remove commented out data [#210](https://github.com/puppetlabs/pdk-templates/pull/210) ([ghoneycutt](https://github.com/ghoneycutt))
- (GH-203) Use the correct ruby version for testing Puppet 6 [#204](https://github.com/puppetlabs/pdk-templates/pull/204) ([ghoneycutt](https://github.com/ghoneycutt))
- Add Visual Studio Code to gitignote (.vscode/) [#202](https://github.com/puppetlabs/pdk-templates/pull/202) ([ghoneycutt](https://github.com/ghoneycutt))
- Ignore .project [#201](https://github.com/puppetlabs/pdk-templates/pull/201) ([ghoneycutt](https://github.com/ghoneycutt))
- ignore .envrc [#200](https://github.com/puppetlabs/pdk-templates/pull/200) ([ghoneycutt](https://github.com/ghoneycutt))
- (GH-196) Fix style for classes and defined types [#197](https://github.com/puppetlabs/pdk-templates/pull/197) ([ghoneycutt](https://github.com/ghoneycutt))
- (GH-192) Fix puppet-strings description of class and defined type [#195](https://github.com/puppetlabs/pdk-templates/pull/195) ([ghoneycutt](https://github.com/ghoneycutt))
- configurable tag_pattern for changelog [#185](https://github.com/puppetlabs/pdk-templates/pull/185) ([rtib](https://github.com/rtib))
- improve travis-ci defaults to leverage build stages [#172](https://github.com/puppetlabs/pdk-templates/pull/172) ([rtib](https://github.com/rtib))

## [1.9.1](https://github.com/puppetlabs/pdk-templates/tree/1.9.1) - 2019-03-01

[Full Changelog](https://github.com/puppetlabs/pdk-templates/compare/1.9.0...1.9.1)

### Added

- Allow more control over puppet-lint options [#181](https://github.com/puppetlabs/pdk-templates/pull/181) ([Felixoid](https://github.com/Felixoid))

### Fixed

- (PDK-1277) Update gitlab-ci config to test against latest Puppets. [#189](https://github.com/puppetlabs/pdk-templates/pull/189) ([bmjen](https://github.com/bmjen))

### Other

- (PDK-1297) Allow the use of aliases in default fact files. [#190](https://github.com/puppetlabs/pdk-templates/pull/190) ([vStone](https://github.com/vStone))
- update short description for `moduleroot_init` [#188](https://github.com/puppetlabs/pdk-templates/pull/188) ([TheMeier](https://github.com/TheMeier))
- Add `update` to the list of commands making use of moduleroot [#186](https://github.com/puppetlabs/pdk-templates/pull/186) ([DavidS](https://github.com/DavidS))
- (PDK-1269) Add plan template [#184](https://github.com/puppetlabs/pdk-templates/pull/184) ([npwalker](https://github.com/npwalker))

## [1.9.0](https://github.com/puppetlabs/pdk-templates/tree/1.9.0) - 2019-01-25

[Full Changelog](https://github.com/puppetlabs/pdk-templates/compare/1.8.0...1.9.0)

### Added

- (WIN-251) Add Bolt Filters to template files [#176](https://github.com/puppetlabs/pdk-templates/pull/176) ([RandomNoun7](https://github.com/RandomNoun7))
- (MAINT) Update JSON pinning to cover Ruby 2.4.5 and future Rubies [#175](https://github.com/puppetlabs/pdk-templates/pull/175) ([scotje](https://github.com/scotje))
- Add options for rspec-puppet coverage reports [#174](https://github.com/puppetlabs/pdk-templates/pull/174) ([genebean](https://github.com/genebean))
- (PDK-1202) Generate a .puppet-lint.rc based on Rakefile [#169](https://github.com/puppetlabs/pdk-templates/pull/169) ([rodjek](https://github.com/rodjek))
- allow configuring the docker image to use in gitlab ci [#137](https://github.com/puppetlabs/pdk-templates/pull/137) ([rtoma](https://github.com/rtoma))

### Fixed

- (FM-7659) - Fix to pin Bundler for Puppet 4 Testing [#173](https://github.com/puppetlabs/pdk-templates/pull/173) ([david22swan](https://github.com/david22swan))
- Fix rubygems-update for ruby older than 2.3 for travis and gitlab-ci [#171](https://github.com/puppetlabs/pdk-templates/pull/171) ([Felixoid](https://github.com/Felixoid))
- (FM-7622) - Remove deprecated config from .travis.yml [#170](https://github.com/puppetlabs/pdk-templates/pull/170) ([eimlav](https://github.com/eimlav))
- (PDK-957) Exclude all development files from module builds [#168](https://github.com/puppetlabs/pdk-templates/pull/168) ([rodjek](https://github.com/rodjek))

### Other

- (MODULES-8444) - Removal of Puppet 4 testing from travis and appveyor [#178](https://github.com/puppetlabs/pdk-templates/pull/178) ([david22swan](https://github.com/david22swan))
- (PDK-1128) Expand the knockout prefix documentation [#177](https://github.com/puppetlabs/pdk-templates/pull/177) ([rodjek](https://github.com/rodjek))

## [1.8.0](https://github.com/puppetlabs/pdk-templates/tree/1.8.0) - 2018-11-27

[Full Changelog](https://github.com/puppetlabs/pdk-templates/compare/1.7.1...1.8.0)

### Added

- add support for travis stages [#166](https://github.com/puppetlabs/pdk-templates/pull/166) ([rtib](https://github.com/rtib))
- (maint) - Update travis.yml to default to ruby 2.5.1 [#162](https://github.com/puppetlabs/pdk-templates/pull/162) ([pmcmaw](https://github.com/pmcmaw))
- (maint) Add optional puppet-strings tasks [#160](https://github.com/puppetlabs/pdk-templates/pull/160) ([DavidS](https://github.com/DavidS))
- Fail on broken spec_helper_local [#152](https://github.com/puppetlabs/pdk-templates/pull/152) ([DavidS](https://github.com/DavidS))

### Other

- (maint) Minor update to .travis.yml notifications [#167](https://github.com/puppetlabs/pdk-templates/pull/167) ([bmjen](https://github.com/bmjen))
- (PDK-1211) Manage .gitattributes when it exists [#163](https://github.com/puppetlabs/pdk-templates/pull/163) ([rodjek](https://github.com/rodjek))
- Changes bunder to bundler in README.md [#158](https://github.com/puppetlabs/pdk-templates/pull/158) ([Rudikza](https://github.com/Rudikza))
- (PDK-1191) Gracefully handle default_fact YAML load errors [#157](https://github.com/puppetlabs/pdk-templates/pull/157) ([rodjek](https://github.com/rodjek))
- (PDK-1210) setting inherited const_defined lookup to false [#156](https://github.com/puppetlabs/pdk-templates/pull/156) ([Thomas-Franklin](https://github.com/Thomas-Franklin))
- (GH-154) Fix appveyor double build [#155](https://github.com/puppetlabs/pdk-templates/pull/155) ([TraGicCode](https://github.com/TraGicCode))
- (PDK-908) Update pdk-template to add data in module files [#153](https://github.com/puppetlabs/pdk-templates/pull/153) ([ardrigh](https://github.com/ardrigh))
- (maint) Prefer LF over CRLF line endings for .epp files [#151](https://github.com/puppetlabs/pdk-templates/pull/151) ([rodjek](https://github.com/rodjek))
- Remove concat_basedir fact [#148](https://github.com/puppetlabs/pdk-templates/pull/148) ([ekohl](https://github.com/ekohl))
- Implement notifications configuration for .travis.yml [#136](https://github.com/puppetlabs/pdk-templates/pull/136) ([nmaludy](https://github.com/nmaludy))

## [1.7.1](https://github.com/puppetlabs/pdk-templates/tree/1.7.1) - 2018-10-05

[Full Changelog](https://github.com/puppetlabs/pdk-templates/compare/1.7.0...1.7.1)

### Fixed

- Remove wrong argument from spec [#147](https://github.com/puppetlabs/pdk-templates/pull/147) ([DavidS](https://github.com/DavidS))

### Other

- Whitespace fixes in README.erb.md [#146](https://github.com/puppetlabs/pdk-templates/pull/146) ([DavidS](https://github.com/DavidS))
- (FM-7398) - Update unit tests for Appveyor to test on Puppet 6 and ruby 2.5.0 [#144](https://github.com/puppetlabs/pdk-templates/pull/144) ([pmcmaw](https://github.com/pmcmaw))
- (FM-7397) - Enable puppet6 testing in travis [#143](https://github.com/puppetlabs/pdk-templates/pull/143) ([pmcmaw](https://github.com/pmcmaw))
- (MODULES-7742) - Update decoration rubocop rule to ignore spec folder [#141](https://github.com/puppetlabs/pdk-templates/pull/141) ([david22swan](https://github.com/david22swan))
- Allow and handle `https?` URLs for git [#135](https://github.com/puppetlabs/pdk-templates/pull/135) ([DavidS](https://github.com/DavidS))
- (maint) several improvements to the provider template [#128](https://github.com/puppetlabs/pdk-templates/pull/128) ([DavidS](https://github.com/DavidS))
- remove concat_basedir from default-facts [#124](https://github.com/puppetlabs/pdk-templates/pull/124) ([TheMeier](https://github.com/TheMeier))
- Rubygems mirror [#108](https://github.com/puppetlabs/pdk-templates/pull/108) ([davidvanlaatum](https://github.com/davidvanlaatum))

## [1.7.0](https://github.com/puppetlabs/pdk-templates/tree/1.7.0) - 2018-08-14

[Full Changelog](https://github.com/puppetlabs/pdk-templates/compare/1.6.1...1.7.0)

### Added

- (FM-7218) Changes to allow the use of parallel spec for the unit test… [#125](https://github.com/puppetlabs/pdk-templates/pull/125) ([david22swan](https://github.com/david22swan))

### Other

- fixing stage job pinning so that spec jobs fall into unit stage [#130](https://github.com/puppetlabs/pdk-templates/pull/130) ([salderma](https://github.com/salderma))
- Fix empty line at the top of the spec_helper.rb [#127](https://github.com/puppetlabs/pdk-templates/pull/127) ([DavidS](https://github.com/DavidS))
- (maint) Remove extra white space in .travis.yml branches [#123](https://github.com/puppetlabs/pdk-templates/pull/123) ([jarretlavallee](https://github.com/jarretlavallee))
- Several beaker-related fixes from #104 [#105](https://github.com/puppetlabs/pdk-templates/pull/105) ([dhollinger](https://github.com/dhollinger))

## [1.6.1](https://github.com/puppetlabs/pdk-templates/tree/1.6.1) - 2018-07-25

[Full Changelog](https://github.com/puppetlabs/pdk-templates/compare/1.6.0...1.6.1)

### Added

- (feature) add github changelog generator template [#111](https://github.com/puppetlabs/pdk-templates/pull/111) ([tphoney](https://github.com/tphoney))

### Fixed

- Remove Layout/IndentHeredoc cop from default config [#117](https://github.com/puppetlabs/pdk-templates/pull/117) ([DavidS](https://github.com/DavidS))

### Other

- (PDK-1066) Use ruby 2.4.4 with travis [#120](https://github.com/puppetlabs/pdk-templates/pull/120) ([vinzent](https://github.com/vinzent))
- (PDK-1044) changelog functions if changelog task [#118](https://github.com/puppetlabs/pdk-templates/pull/118) ([tphoney](https://github.com/tphoney))
- (GH#530) Change quotes around hiera_config to single quotes [#116](https://github.com/puppetlabs/pdk-templates/pull/116) ([rodjek](https://github.com/rodjek))
- add ability to support BEAKER_TESTMODE [#115](https://github.com/puppetlabs/pdk-templates/pull/115) ([b4ldr](https://github.com/b4ldr))
- Add option to specify except branches in .travis.yml [#97](https://github.com/puppetlabs/pdk-templates/pull/97) ([jarretlavallee](https://github.com/jarretlavallee))

## [1.6.0](https://github.com/puppetlabs/pdk-templates/tree/1.6.0) - 2018-06-20

[Full Changelog](https://github.com/puppetlabs/pdk-templates/compare/1.5.0...1.6.0)

### Added

- (feature) Allow code coverage in .travis.yml [#110](https://github.com/puppetlabs/pdk-templates/pull/110) ([tphoney](https://github.com/tphoney))
- (PDK-681) Remove puppet-blacksmith [#79](https://github.com/puppetlabs/pdk-templates/pull/79) ([DavidS](https://github.com/DavidS))
- (maint) Remove Geppetto support [#58](https://github.com/puppetlabs/pdk-templates/pull/58) ([DavidS](https://github.com/DavidS))
- Make deploy optional in .travis.yml [#32](https://github.com/puppetlabs/pdk-templates/pull/32) ([ardrigh](https://github.com/ardrigh))

### Fixed

- (PDK-903) ignore `.git` directory [#106](https://github.com/puppetlabs/pdk-templates/pull/106) ([DavidS](https://github.com/DavidS))
- revise Style/Documentation excludes [#103](https://github.com/puppetlabs/pdk-templates/pull/103) ([DavidS](https://github.com/DavidS))
- (PDK-998) Fix rubocop "off" profile [#102](https://github.com/puppetlabs/pdk-templates/pull/102) ([DavidS](https://github.com/DavidS))
- (PDK-981) Make .gitlab-ci look like .travis [#83](https://github.com/puppetlabs/pdk-templates/pull/83) ([npwalker](https://github.com/npwalker))
- fix lint disable checks [#56](https://github.com/puppetlabs/pdk-templates/pull/56) ([TheMeier](https://github.com/TheMeier))

### Other

- Whitespace fix for `.travis.yml` [#113](https://github.com/puppetlabs/pdk-templates/pull/113) ([DavidS](https://github.com/DavidS))
- (maint) Add a note about the knockout_prefix [#107](https://github.com/puppetlabs/pdk-templates/pull/107) ([jarretlavallee](https://github.com/jarretlavallee))
- Fix newline warning in updated spec_helper and improve pre-merge CI testing [#100](https://github.com/puppetlabs/pdk-templates/pull/100) ([scotje](https://github.com/scotje))
- (FIXUP) Fix rubocop validation failure for new provider spec tests [#99](https://github.com/puppetlabs/pdk-templates/pull/99) ([scotje](https://github.com/scotje))
- (MAINT) Remove gem update bundler from before_install [#96](https://github.com/puppetlabs/pdk-templates/pull/96) ([npwalker](https://github.com/npwalker))
- Make gitlab cache configurable [#93](https://github.com/puppetlabs/pdk-templates/pull/93) ([dhollinger](https://github.com/dhollinger))
- Add travis testing to ensure template changes work [#90](https://github.com/puppetlabs/pdk-templates/pull/90) ([npwalker](https://github.com/npwalker))
- (PDK-987) Save CI resources / reduce developer feedback time [#88](https://github.com/puppetlabs/pdk-templates/pull/88) ([npwalker](https://github.com/npwalker))
- deprecating README Reference section [#87](https://github.com/puppetlabs/pdk-templates/pull/87) ([jbondpdx](https://github.com/jbondpdx))
- (PDK-986) Only run parts of release_check task [#84](https://github.com/puppetlabs/pdk-templates/pull/84) ([npwalker](https://github.com/npwalker))
- Addition of global_env section alongside configuration and docs update [#82](https://github.com/puppetlabs/pdk-templates/pull/82) ([HelenCampbell](https://github.com/HelenCampbell))
- Gitlab jobs parsing [#81](https://github.com/puppetlabs/pdk-templates/pull/81) ([dhollinger](https://github.com/dhollinger))
- Update rubocop ignores for nested Gemfile, Rakefile, Puppetfile, and Vagrantfile [#77](https://github.com/puppetlabs/pdk-templates/pull/77) ([cdenneen](https://github.com/cdenneen))
- More Gitlab CI improvements [#76](https://github.com/puppetlabs/pdk-templates/pull/76) ([dhollinger](https://github.com/dhollinger))
- (MODULES-6891) - Enable puppet 5 installation when using beaker-puppet_install_helper on travis [#75](https://github.com/puppetlabs/pdk-templates/pull/75) ([pmcmaw](https://github.com/pmcmaw))
- (PDK-967) Add an option to specify additional lines in Rakefile [#73](https://github.com/puppetlabs/pdk-templates/pull/73) ([jarretlavallee](https://github.com/jarretlavallee))
- Add quotes around the spec_helper's hiera_config [#72](https://github.com/puppetlabs/pdk-templates/pull/72) ([jarretlavallee](https://github.com/jarretlavallee))
- Update Gitlab template to be more configurable [#71](https://github.com/puppetlabs/pdk-templates/pull/71) ([dhollinger](https://github.com/dhollinger))
- Default to parallel specs in CI [#69](https://github.com/puppetlabs/pdk-templates/pull/69) ([npwalker](https://github.com/npwalker))
- (PDK-964) Use gitlab ci caching [#68](https://github.com/puppetlabs/pdk-templates/pull/68) ([npwalker](https://github.com/npwalker))
- Add a remove_includes configuration option [#67](https://github.com/puppetlabs/pdk-templates/pull/67) ([npwalker](https://github.com/npwalker))
- Add yaml header to make yamllint happy [#65](https://github.com/puppetlabs/pdk-templates/pull/65) ([wmuizelaar](https://github.com/wmuizelaar))
- (maint) exclude lib/ directory from Style/Documentation cop [#46](https://github.com/puppetlabs/pdk-templates/pull/46) ([eputnam](https://github.com/eputnam))

## [1.5.0](https://github.com/puppetlabs/pdk-templates/tree/1.5.0) - 2018-04-30

[Full Changelog](https://github.com/puppetlabs/pdk-templates/compare/1.4.1...1.5.0)

### Added

- (PDK-846) unit test for type and cleanup [#40](https://github.com/puppetlabs/pdk-templates/pull/40) ([tphoney](https://github.com/tphoney))

### Fixed

- (PDK-911) fix ensure symbol/string handling [#48](https://github.com/puppetlabs/pdk-templates/pull/48) ([DavidS](https://github.com/DavidS))

### Other

- (doc) update link to writing tasks docs [#64](https://github.com/puppetlabs/pdk-templates/pull/64) ([adreyer](https://github.com/adreyer))
- Added ability to set structured extra facts [#63](https://github.com/puppetlabs/pdk-templates/pull/63) ([dylanratcliffe](https://github.com/dylanratcliffe))
- (maint) Loosen up json pin to account for Beaker deps. [#62](https://github.com/puppetlabs/pdk-templates/pull/62) ([bmjen](https://github.com/bmjen))
- (FIXUP) json gem pin needs to remain at 2.0.4 for Ruby 2.4.4 [#61](https://github.com/puppetlabs/pdk-templates/pull/61) ([scotje](https://github.com/scotje))
- (maint) Update json pin for Ruby 2.4.4 [#60](https://github.com/puppetlabs/pdk-templates/pull/60) ([bmjen](https://github.com/bmjen))
- (maint) Move .project template so it can be deleted or unmanaged. [#53](https://github.com/puppetlabs/pdk-templates/pull/53) ([bmjen](https://github.com/bmjen))
- (PDK-922) remove resource names from generated comments [#52](https://github.com/puppetlabs/pdk-templates/pull/52) ([eputnam](https://github.com/eputnam))
- Fixing a typo in the comment. [#50](https://github.com/puppetlabs/pdk-templates/pull/50) ([brucetimberlake](https://github.com/brucetimberlake))
- (PDK-916) Avoid the PSH deprecation when not specifying mock_with [#49](https://github.com/puppetlabs/pdk-templates/pull/49) ([DavidS](https://github.com/DavidS))
- (maint) remove redundant require [#47](https://github.com/puppetlabs/pdk-templates/pull/47) ([DavidS](https://github.com/DavidS))
- (MAINT) Add json pin for Ruby 2.4.3 [#45](https://github.com/puppetlabs/pdk-templates/pull/45) ([scotje](https://github.com/scotje))
- (PDK-706) Remove vulnerable puppet3 support dependencies [#42](https://github.com/puppetlabs/pdk-templates/pull/42) ([bmjen](https://github.com/bmjen))
- Addition of release_checks to travis [#39](https://github.com/puppetlabs/pdk-templates/pull/39) ([HelenCampbell](https://github.com/HelenCampbell))
- (MODULES-6828) Add blacksmith to Gemfile and Rakefile [#38](https://github.com/puppetlabs/pdk-templates/pull/38) ([HelenCampbell](https://github.com/HelenCampbell))
- (MODULES-6781) Update Rakefile to allow disabling Lint rules [#37](https://github.com/puppetlabs/pdk-templates/pull/37) ([HelenCampbell](https://github.com/HelenCampbell))
- (PDK-511) Add strict checking for PDK unit test templates [#36](https://github.com/puppetlabs/pdk-templates/pull/36) ([da-ar](https://github.com/da-ar))
- Use -f not || true when removing Gemfile.lock [#35](https://github.com/puppetlabs/pdk-templates/pull/35) ([HelenCampbell](https://github.com/HelenCampbell))
- Add `update_report.txt` to ignore files [#34](https://github.com/puppetlabs/pdk-templates/pull/34) ([DavidS](https://github.com/DavidS))
- Fix Gemfile template [#33](https://github.com/puppetlabs/pdk-templates/pull/33) ([bodgit](https://github.com/bodgit))
- Removing duplicate log value in gitignore [#31](https://github.com/puppetlabs/pdk-templates/pull/31) ([HelenCampbell](https://github.com/HelenCampbell))

## [1.4.1](https://github.com/puppetlabs/pdk-templates/tree/1.4.1) - 2018-02-22

[Full Changelog](https://github.com/puppetlabs/pdk-templates/compare/1.4.0...1.4.1)

## [1.4.0](https://github.com/puppetlabs/pdk-templates/tree/1.4.0) - 2018-02-21

[Full Changelog](https://github.com/puppetlabs/pdk-templates/compare/1.3.2...1.4.0)

### Added

- Add option to enable rubocop todos [#19](https://github.com/puppetlabs/pdk-templates/pull/19) ([DavidS](https://github.com/DavidS))

### Fixed

- Fix geppetto metadata to work with newer versions of eclipse [#28](https://github.com/puppetlabs/pdk-templates/pull/28) ([hdeheer](https://github.com/hdeheer))

### Other

- (maint) avoid using Command API for new provider example [#29](https://github.com/puppetlabs/pdk-templates/pull/29) ([DavidS](https://github.com/DavidS))
- Additional changes to travis and appveyor [#27](https://github.com/puppetlabs/pdk-templates/pull/27) ([HelenCampbell](https://github.com/HelenCampbell))
- Customization of default_facts.yml [#26](https://github.com/puppetlabs/pdk-templates/pull/26) ([bmjen](https://github.com/bmjen))
- (maint) Allows customization of .yardopts [#25](https://github.com/puppetlabs/pdk-templates/pull/25) ([bmjen](https://github.com/bmjen))
- Succeed with unsupported rubocop versions [#23](https://github.com/puppetlabs/pdk-templates/pull/23) ([DavidS](https://github.com/DavidS))
- (PDK-776) Refactors ignore files for git and pdk, removes pmtignore. [#20](https://github.com/puppetlabs/pdk-templates/pull/20) ([bmjen](https://github.com/bmjen))
- Removing openssl issue from appveyor config as is no longer required [#16](https://github.com/puppetlabs/pdk-templates/pull/16) ([HelenCampbell](https://github.com/HelenCampbell))
- Add DS_store to gitignore [#15](https://github.com/puppetlabs/pdk-templates/pull/15) ([HelenCampbell](https://github.com/HelenCampbell))
- (maint) Adds spec_helper_local support to spec_helper.rb [#14](https://github.com/puppetlabs/pdk-templates/pull/14) ([bmjen](https://github.com/bmjen))
- (PDK-506) Resource API-based provider template [#13](https://github.com/puppetlabs/pdk-templates/pull/13) ([DavidS](https://github.com/DavidS))
- Fixing a typo in config_defaults for appveyor [#12](https://github.com/puppetlabs/pdk-templates/pull/12) ([HelenCampbell](https://github.com/HelenCampbell))

## [1.3.2](https://github.com/puppetlabs/pdk-templates/tree/1.3.2) - 2018-01-16

[Full Changelog](https://github.com/puppetlabs/pdk-templates/compare/1.3.1...1.3.2)

## [1.3.1](https://github.com/puppetlabs/pdk-templates/tree/1.3.1) - 2018-01-15

[Full Changelog](https://github.com/puppetlabs/pdk-templates/compare/1.3.0...1.3.1)

### Other

- Fix empty config issue with .travis.yml.erb [#11](https://github.com/puppetlabs/pdk-templates/pull/11) ([HelenCampbell](https://github.com/HelenCampbell))
- Updates format .travis.yml.erb for branches config [#10](https://github.com/puppetlabs/pdk-templates/pull/10) ([HelenCampbell](https://github.com/HelenCampbell))
- Updating README with template url usage [#9](https://github.com/puppetlabs/pdk-templates/pull/9) ([pmcmaw](https://github.com/pmcmaw))
- Make travis branches configurable [#8](https://github.com/puppetlabs/pdk-templates/pull/8) ([HelenCampbell](https://github.com/HelenCampbell))
- Update RakeFile to be configurable. [#7](https://github.com/puppetlabs/pdk-templates/pull/7) ([HelenCampbell](https://github.com/HelenCampbell))
- Addition of 'optional' key in Gemfile readme [#6](https://github.com/puppetlabs/pdk-templates/pull/6) ([HelenCampbell](https://github.com/HelenCampbell))
- (MODULES-6333) Add Puppet 5 to matrix for travis and appveyor [#4](https://github.com/puppetlabs/pdk-templates/pull/4) ([HelenCampbell](https://github.com/HelenCampbell))

## [1.3.0](https://github.com/puppetlabs/pdk-templates/tree/1.3.0) - 2017-12-15

[Full Changelog](https://github.com/puppetlabs/pdk-templates/compare/439118c7c30f13679af8eea20e0afa4ff1922a6f...1.3.0)
