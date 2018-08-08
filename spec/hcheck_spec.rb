RSpec.describe Hcheck do
  it 'has a version number' do
    expect(Hcheck::VERSION).not_to be nil
  end

  describe '.configure' do
    before do
      Hcheck.configure(
        postgresql: {
          host: 'localhost',
          port: '5432',
          username: '',
          password: '',
          database: ''
        }
      )
    end

    it 'initialize configuration' do
      expect(Hcheck.configuration).to be_an_instance_of(Hcheck::Configuration)
    end
  end
end
