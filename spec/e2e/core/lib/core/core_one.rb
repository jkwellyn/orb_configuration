require 'orb_configuration'

module Core
  class CoreOne
    include OrbConfiguration::Configurable

    attr_reader :config

    def initialize
      @config = OrbConfiguration::Configuration.instance
    end
  end
end
