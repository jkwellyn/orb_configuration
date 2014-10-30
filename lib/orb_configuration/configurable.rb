require 'logger'
require_relative 'configuration'

module OrbConfiguration
  module Configurable
    class << self
      def included(_parent)
        # calling_file is the file name of the Ruby code that is our parent in the call stack.
        calling_file = caller.first.split(':').first
        config_path = Configuration.resolve_config_path(calling_file)
        if File.exist?(config_path)
          Configuration.instance.add!(config_path)
        else
          log = Logger.new(STDOUT)
          log.warn("Expected config directory #{config_path} not found. Not loading configuration")
        end
      end
    end
  end
end