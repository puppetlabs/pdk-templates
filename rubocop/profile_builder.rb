#!/usr/bin/env ruby
# frozen_string_literal: true

this_dir = __dir__
raise "This script must be run from the #{this_dir} directory" if this_dir != Dir.pwd

require 'fileutils'
require 'yaml'
require 'rubocop/version'

def report_cops(cops, msg)
  warn "Found these cops in #{msg}:"
  total = 0
  cops.each do |enabled, c|
    warn "#{enabled.inspect}: #{c.length}"
    total += c.length
  end
  warn "total: #{total}"
end

def load_config
  YAML.safe_load(`rubocop --show-cops --require rubocop-rspec --require rubocop-performance`)
end

File.delete('.rubocop.yml') if File.exist?('.rubocop.yml')

default_configs = load_config
all_cops = default_configs.keys - ['AllCops', 'require', 'Lint/Syntax']

default_cops = all_cops.group_by { |c| default_configs[c]['Enabled'] }
report_cops(default_cops, 'the rubocop config')

File.open("defaults-#{RuboCop::Version.version}.yml", 'wb') do |f|
  f.puts YAML.dump(
    default_enabled_cops: default_cops[true].sort,
    default_pending_cops: default_cops['pending'].sort
  )
end

# # fetch config from current PDK.  Assume it's in the same directory as this repo.
# FileUtils.cp(File.join('..', '..', 'pdk', '.rubocop.yml'), '.')
# # stub out the included config to avoid rubocop complaints
# File.open('.rubocop_todo.yml', 'w') do |f|
#   # nothing
# end
# # config = YAML.load(File.read('.rubocop.yml'))

# all_cops_configured = load_config

# configured_cops = all_cops.group_by { |c| all_cops_configured[c]['Enabled'] }
# report_cops(configured_cops, "the pdk config")

# # The cleanups_only profile only has the uncontroversial cops enabled, and configured, everything else is disabled

# configured_cleanup_cops = YAML.load(File.read('cleanup_cops.yml'))

# cleanup_cops = {
#   true: all_cops - configured_cops[false] - configured_cops['pending'],
#   false: all_cops - configured_cops[true],
# }

# report_cops(cleanup_cops, "the cleanup section")

# # force_disabled_cops = config_disabled_cops - default_disabled_cops

# # puts YAML.dump(config_enabled_cops - cleanup_enabled_cops)
