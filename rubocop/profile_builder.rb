#!/usr/bin/env ruby

this_dir = __dir__
raise "This script must be run from the #{this_dir} directory" if this_dir != Dir.pwd

require 'yaml'
require 'rubocop/version'

File.delete('.rubocop.yml') if File.exist?('.rubocop.yml')

default_configs = YAML.load(`rubocop --show-cops --require rubocop-rspec --require rubocop-i18n`)
all_cops = default_configs.keys - [ 'AllCops', 'require' ]
default_enabled_cops = all_cops.find_all { |c| default_configs[c]['Enabled'] }
default_disabled_cops = all_cops - default_enabled_cops

$stderr.puts "Found #{default_enabled_cops.length} enabled, and #{default_disabled_cops.length} disabled cops in the default config."

# fetch config from current PDK.  Assume it's in the same directory as this repo.
FileUtils.cp(File.join('..', '..', 'pdk', '.rubocop.yml'), '.')
# stub out the included config to avoid rubocop complaints
File.open('.rubocop_todo.yml', 'w') do |f|
  # nothing
end
config = YAML.load(File.read('.rubocop.yml'))

configured_cops = YAML.load(`rubocop --show-cops`)
config_enabled_cops = all_cops.find_all { |c| configured_cops[c] && configured_cops[c]['Enabled'] }
config_disabled_cops = all_cops - config_enabled_cops

$stderr.puts "Found #{config_enabled_cops.length} enabled, and #{config_disabled_cops.length} disabled cops in the recommended config."

# The cleanups_only profile only has the uncontroversial cops enabled, and configred, everything else is disabled

cleanup_cops = YAML.load(File.read('cleanup_cops.yml'))

cleanup_enabled_cops = cleanup_cops - config_disabled_cops
cleanup_disabled_cops = all_cops - cleanup_enabled_cops

$stderr.puts "Found #{cleanup_enabled_cops.length} enabled, and #{cleanup_disabled_cops.length} disabled cops in the cleanup config."

force_disabled_cops = config_disabled_cops - default_disabled_cops

# all_cops.each do |c|
#   if default_enabled
#     if disabled
#       # render
#     end
#   else
#     if enabled
#       # render
#     end
#   end
# end
File.open("defaults-#{RuboCop::Version.version}.yml", 'wb') do |f|
  f.puts YAML.dump(default_enabled_cops: default_enabled_cops)
end

puts YAML.dump(config_enabled_cops - cleanup_enabled_cops)
