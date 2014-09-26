require 'active_support/all'
require 'forwardable'
require 'recursive-open-struct'
require 'singleton'
require 'yaml'
require 'orb_logger'

module OrbConfiguration
  class FileNotFoundException < Exception
  end

  # Provides access to data in 'config/config.yml'. Supports both [:property] and '.property' style access
  # to yml configuration.
  class Configuration
    include ::Singleton
    extend ::Forwardable

    DEFAULT_CONFIGURATION_DIRECTORY = 'config'
    DEFAULT_CONFIGURATION_FILE_NAME = "#{DEFAULT_CONFIGURATION_DIRECTORY}.yml"
    CODE_DIRECTORIES = %w(lib spec)
    LOG ||= OrbLogger::OrbLogger.new

    def_delegators :@data_hash, :[]

    class << self
      # @param [String] calling_file path of the file that invoked this code.
      # @return [String] path to the configuration file based on the location of the calling file
      def resolve_config_path(calling_file)
        config_location = File.join(Configuration::DEFAULT_CONFIGURATION_DIRECTORY,
                                    Configuration::DEFAULT_CONFIGURATION_FILE_NAME)

        execution_directories = CODE_DIRECTORIES.select { |dir| calling_file.include?(dir) }
        if execution_directories.length > 1
          warn_message = 'This project has a non-conventional structure (nested lib or spec directories). ' \
         'We may not be able to find your config file.'
          LOG.warn(warn_message)
        end

        File.join(calling_file.split(execution_directories.first).first, config_location)
      end
    end

    # Allows the user to specify a config file other than 'config/config.yml'.
    # @param [String] config_path provided as a convenience, but should be avoided in favor of the default location.
    # @return [Nil] nil
    def add!(config_path = nil)
      calling_code_file_path = caller.first.split(':').first
      config_path ||= Configuration.resolve_config_path(calling_code_file_path)
      fail(FileNotFoundException, "#{config_path} not found") unless File.exist?(config_path)
      @data_hash = @data_hash.nil? ? YAML.load_file(config_path) : @data_hash.deep_merge(YAML.load_file(config_path))
      @data_model = RecursiveOpenStruct.new(@data_hash, recurse_over_arrays: true)
      nil
    end

    def parse_key(config_key)
      fail 'config_key required.' if config_key.nil? || config_key.empty?
      parse_key_recursive(@data_model, config_key.split('.').reverse, '')
    end

    def method_missing(method, *args, &block)
      @data_model.send(method, *args, &block)
    end

    def empty?
      @data_model.nil?
    end

    def reset!
      @data_model = nil
      @data_hash = nil
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
