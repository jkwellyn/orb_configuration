require 'forwardable'
require 'recursive-open-struct'
require 'singleton'
require 'yaml'
require 'orb_logger'

module OrbConfiguration
  # Provides access to data in 'config/config.yml'. Supports both [:property] and '.property' style access
  # to yml configuration.
  class Configuration
    include ::Singleton
    extend ::Forwardable

    DEFAULT_CONFIGURATION_FILE_NAME = 'config.yml'
    DEFAULT_CONFIGURATION_DIRECTORY = 'config'
    DEFAULT_CONFIGURATION_LOCATION = File.join(Dir.pwd, DEFAULT_CONFIGURATION_DIRECTORY, DEFAULT_CONFIGURATION_FILE_NAME)
    LOG ||= OrbLogger::OrbLogger.new
    def_delegators :@data_hash, :[]

    attr_reader :data_hash
    attr_reader :data_model

    def initialize
      read_configuration!(DEFAULT_CONFIGURATION_LOCATION)
    end

    # Allows the user to specify a config file other than 'config/config.yml'.
    # This is provided as a convenience, but should be avoided in favor of the default location when possible.
    # @param [String] config_path Overrides default configuration location.
    def read_configuration!(config_path)
      if File.exist?(config_path)
        @data_hash = YAML.load_file(config_path)
        @data_model = RecursiveOpenStruct.new(@data_hash, recurse_over_arrays: true)
      else
        warning_message = "#{config_path} not found. Not loading any configuration data. " \
        "To read data, provide #{config_path} or call #read_config!(path) with some other file."
        LOG.warn(warning_message)
      end
      nil
    end

    def parse_key(config_key)
      fail 'config_key required.' if config_key.nil? || config_key.empty?
      parse_key_recursive(@data_model, config_key.split('.').reverse, '')
    end

    def method_missing(method, *args, &block)
      @data_model.send(method, *args, &block)
    end

    private

    def parse_key_recursive(data_model, config_keys, key_message)
      if config_keys.length > 0
        config_key = config_keys.pop
        key_message << config_key
        configuration = data_model.send(config_key.to_sym)
        fail("config_key #{key_message} has no defined value.") unless configuration
        parse_key_recursive(configuration, config_keys, key_message << '.')
      else
        data_model
      end
    end
  end
end
