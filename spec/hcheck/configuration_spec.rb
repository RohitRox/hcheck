RSpec.describe Hcheck::Configuration do
  let(:default_file_config) do
    YAML.safe_load(ERB.new(File.read("#{Dir.pwd}/hcheck.yml")).result, [Symbol])
  end

  describe '.load' do
    it 'configures Hcheck with supplied argument' do
      config = { postgres: { host: 'localhost' } }
      expect(Hcheck).to receive(:configure).with config

      Hcheck::Configuration.load(config)
    end
  end

  describe '.load_default' do
    it 'loads hcheck.yml found in the current dir' do
      expect(Hcheck::Configuration).to receive(:load).with default_file_config

      Hcheck::Configuration.load_default
    end
  end

  describe '.load_argv' do
    context 'when argv -C/--config was supplied' do
      it 'configures Hcheck with supplied config file path' do
        expect(Hcheck::Configuration).to receive(:load).with default_file_config

        Hcheck::Configuration.load_argv(['-C', Hcheck::Configuration::DEFAULT_CONFIG_PATH])
      end
    end

    context 'when argv -c/--config was not supplied' do
      it 'does not configure Hcheck' do
        expect(Hcheck::Configuration).not_to receive(:load).with default_file_config

        Hcheck::Configuration.load_argv([])
      end
    end
  end
end
