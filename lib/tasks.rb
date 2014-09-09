#!/usr/bin/env rake
require 'rubocop/rake_task'
require 'annotation_manager/rake_task'
require 'orb_logger'
require 'yard'

RAKE_LOG ||= OrbLogger::OrbLogger.new
RAKE_LOG.progname = 'Rake Tasks'

YARD::Rake::YardocTask.new do |task|
  task.options = ['--output-dir=tmp/yard']
end

desc 'Run RuboCop on lib and spec directories, Gemfile, gemspec, Rakefile; Override with a space delimited list'
RuboCop::RakeTask.new(:rubocop, :pattern) do |task, args|
  task.patterns = ['lib/**/*.rb', 'spec/**/*.rb', 'Gemfile', '*.gemspec', 'Rakefile']
  task.patterns = args[:pattern].split(' ') if args[:pattern] # override default pattern
  RAKE_LOG.info("Running RuboCop against #{task.patterns}")
  # don't abort rake on failure
  task.fail_on_error = false
end

require 'test_support/tasks/clean'
require 'test_support/tasks/spec'
