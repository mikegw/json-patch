# frozen_string_literal: true

ENV['gem_push'] = 'no'
require 'bundler/gem_tasks'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = ['--format progress']
end

require 'rubocop/rake_task'
RuboCop::RakeTask.new

require 'steep/rake_task'
Steep::RakeTask.new

default_tasks = %i[rubocop spec]
default_tasks << :steep if RUBY_VERSION >= '3.3.2'

task default: default_tasks
