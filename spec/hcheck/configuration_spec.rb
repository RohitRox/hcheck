RSpec.describe Hcheck::Configuration do
  FIXTURE_FILE_PATH = "#{Dir.pwd}/spec/fixtures/hcheck.yml"

  let(:fixture_file_config) do
    YAML.safe_load(ERB.new(File.read(FIXTURE_FILE_PATH)).result, [Symbol])
  end

  describe '.load' do
    it 'configures Hcheck with supplied argument' do
      config = { postgres: { host: 'localhost' } }
      expect(Hcheck).to receive(:configure).with config

      Hcheck::Configuration.load(config)
    end
  end

  describe '.read' do
    it 'reads yaml file' do
      expect(Hcheck::Configuration.read(FIXTURE_FILE_PATH)).to eql fixture_file_config
    end
  end

  describe '.load_file' do
    it 'loads supplied hcheck.yml file path' do
      config = double(:config)
      expect(Hcheck::Configuration).to receive(:read).with(FIXTURE_FILE_PATH).and_return config
      expect(Hcheck::Configuration).to receive(:load).with config

      Hcheck::Configuration.load_file(FIXTURE_FILE_PATH)
    end
  end

  describe '.load_default' do
    it 'loads hcheck.yml found in the current dir' do
      expect(Hcheck::Configuration).to receive(:load_file).with Hcheck::Configuration::DEFAULT_CONFIG_PATH

      Hcheck::Configuration.load_default
    end
  end

  describe '.load_argv' do
    context 'when argv -C/--config was supplied' do
      it 'configures Hcheck with supplied config file path' do
        expect(Hcheck::Configuration).to receive(:load_file).with FIXTURE_FILE_PATH

        Hcheck::Configuration.load_argv(['-C', FIXTURE_FILE_PATH])
      end
    end

    context 'when argv -c/--config was not supplied' do
      it 'does not configure Hcheck' do
        expect(Hcheck::Configuration).not_to receive(:load_file)

        Hcheck::Configuration.load_argv([])
      end
    end
  end
end
