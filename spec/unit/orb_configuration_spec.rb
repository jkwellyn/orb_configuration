require_relative '../../lib/orb_configuration/configuration'

module OrbConfiguration
  describe Configuration do
    context 'singleton creation' do
      it 'only creates one instance' do
        config = Configuration.instance
        expect(config).to eql(Configuration.instance)
      end

      it '#new throws error' do
        expect { Configuration.new }.to raise_error(NoMethodError)
      end
    end

    context 'instance methods' do
      let(:config) do
        config = Configuration.instance
        config.add!(File.join(File.dirname(__FILE__), '..', 'fixtures', 'config.yml'))
        config
      end
      context 'delegated methods' do
        it '#[] accepts a symbol and provides access to config data' do
          expect(config[:test][:foo]).to eq('bar')
        end

        it '#[] accepts a string and provides access to config data' do
          expect(config['other_test']).to eq(123)
        end
      end

      context 'config properties are methods' do
        it '#method_missing forwards methods to internal RecursiveStruct' do
          expect(config.test.foo).to eq('bar')
        end

        it '#method_missing returns nil when internal RecursiveStruct has no associated property' do
          expect(config.fake).to be_nil
        end
      end

      context 'configuration string parsing' do
        it '#parse_config_key returns the correct property value for the given string' do
          expect(config.parse_key('test.foo')).to eq('bar')
          expect(config.parse_key('test').foo).to eq('bar')
        end
        it '#parse_config_key throws an error for nonexistant keys' do
          # Providing 'fail' does not throw the error I expect. I am not sure why.
          # expect(config.parse_config_key('fail')).to eq('bar')
          expect { config.parse_key('nope') }.to raise_error(RuntimeError)
          expect { config.parse_key('nope.again') }.to raise_error(RuntimeError)
        end
      end

      context 'read config file' do
        it 'add! throws FileNotFoundException if there is no file.' do
          expect { config.add!('') }.to raise_error(FileNotFoundException)
        end
      end

      it '#empty? should return false if config file was read.' do
        expect(config.empty?).to be false
      end

      it '#empty? should return true if no config file was read.' do
        config.reset!
        expect(config.empty?).to be true
      end

    end

    context 'class methods' do
      it '::resolve_config_path creates correct path when under the lib directory' do
        config_path = Configuration.resolve_config_path('/foo/bar/lib/file.rb')
        expect(config_path).to eq('/foo/bar/config/config.yml')
      end

      it '::resolve_config_path creates correct path when under two lib directories' do
        config_path = Configuration.resolve_config_path('/foo/bar/lib/lib/lib/file.rb')
        expect(config_path).to eq('/foo/bar/config/config.yml')
      end

      it '::resolve_config_path creates correct path when under two non-consecutive lib directories' do
        config_path = Configuration.resolve_config_path('/foo/bar/lib/fake/lib/file.rb')
        expect(config_path).to eq('/foo/bar/config/config.yml')
      end
    end
  end
end
