RSpec.describe 'Hcheck::Checks::Memcached' do
  include Hcheck::Checks::Memcached

  describe '#status' do
    let(:url) { 'MEMCACHED_DB_URL' }
    let(:other_config) do
      {
        namespace: 'MEMCACHED_DB_NAMESPACE',
        compress: 'MEMCACHED_DB_COMPRESS'
      }
    end
    let(:config) { {url: url}.merge(other_config) }
    let(:connection) { double('Dalli::Client', set: 'ok', get: 'ok') }

    before do
      allow(Dalli::Client).to receive(:new) { connection }
    end

    subject { status(config) }

    it 'tries to make Memcached connection with supplied config' do
      expect(Dalli::Client).to receive(:new).with(url, other_config)
      subject
    end

    context 'when hcheck is able to connect to Memcached with supplied config' do
      it 'returns ok' do
        expect(subject).to eql 'ok'
      end
    end

    context 'when hcheck is not able to connect to Memcached with supplied config' do
      it 'returns bad' do
        allow(connection).to receive(:set).and_raise(Dalli::RingError)
        expect(subject).to eql 'bad'
      end
    end
  end
end
