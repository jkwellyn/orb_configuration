require_relative '../../lib/orb_configuration/configurable'
require_relative '../../lib/orb_configuration/configuration'

module OrbConfiguration
  describe Configurable do
    context 'hooks' do
      it 'fails on include when config/config.yml not found' do
        expect do
          class ConfigTest
            include Configurable
          end
        end.not_to raise_error
      end
    end
  end
end
