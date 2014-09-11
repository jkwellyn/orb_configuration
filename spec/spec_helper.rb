require 'simplecov'
require 'test_support/filesystem_helper'

SimpleCov.start do
  coverage_dir 'tmp/coverage/unit'
  add_filter 'tmp/'
  add_filter 'spec/'
end

RSpec.configure do |config|
  # Only accept expect syntax do not allow old should syntax
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

require 'orb_logger'
LOG ||= OrbLogger::OrbLogger.new
LOG.progname = 'Test Execution' # TODO: replace with whatever progname you want
