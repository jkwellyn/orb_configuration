require 'active_support/all'
require 'forwardable'
require 'recursive-open-struct'
require 'singleton'
require 'logger'
require 'yaml'

module OrbConfiguration
  class FileNotFoundException < Exception
  end

  class NilConfigException < Exception
  end

  # Provides access to data in 'config/config.yml'. Supports both [:property] and '.property' style access
  # to yml configuration.
  class Configuration
    include ::Singleton
    extend ::Forwardable

    DEFAULT_CONFIGURATION_DIRECTORY = 'config'
    DEFAULT_CONFIGURATION_FILE_NAME = "#{DEFAULT_CONFIGURATION_DIRECTORY}.yml"
    CODE_DIRECTORIES = %w(lib spec)

    def_delegators :@data_hash, :[]
    LOG = Logger.new(STDOUT)

    class << self
      # @param [String] calling_file path of the file that invoked this code.
      # @return [String] path to the configuration file based on the location of the calling file
      def resolve_config_path(calling_file)
        config_location = File.join(Configuration::DEFAULT_CONFIGURATION_DIRECTORY,
                                    Configuration::DEFAULT_CONFIGURATION_FILE_NAME)

        File.join(find_execution_path(calling_file), '..', config_location)
      end

      # Finds a Ruby project's lib directory by looking for a Gemfile sibling.
      # @param [String] path The path in which to look for the project's lib directory.
      def find_execution_path(path)
        path = File.extname(path).empty? ? path : File.dirname(path)
        execution_dirs = CODE_DIRECTORIES.select { |dir| path.include?(dir) }
        execution_dir_name = execution_dirs.first
        candidate_dirs = path.split(execution_dir_name << File::SEPARATOR)
        candidate_dirs.reduce do |parent_dir, child_dir|
          puts parent_dir
          puts child_dir
          if File.exist?(File.join(parent_dir, 'Gemfile'))
            File.join(parent_dir, execution_dir_name)
          else
            File.join(parent_dir, execution_dir_name, child_dir)
          end
        end
      end
    end

    # Allows the user to specify a config file other than 'config/config.yml'.
    # @param [String] config_path provided as a convenience, but should be avoided in favor of the default location.
    # @return nil
    def add!(config_path = nil)
      calling_code_file_path = caller.first.split(':').first
      config_path ||= Configuration.resolve_config_path(calling_code_file_path)
      fail(FileNotFoundException, "#{config_path} not found") unless File.exist?(config_path)
      merge!(YAML.load_file(config_path))
    end

    # Set and merge config at runtime without a file.
    # @param {Hash} configuration data
    # @return nil
    def merge!(config = {})
      fail(NilConfigException, 'Config cannot be nil.') if config.nil?
      @data_hash = @data_hash.nil? ? config : @data_hash.deep_merge(config)
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
