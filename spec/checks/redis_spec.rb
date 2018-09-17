RSpec.describe Hcheck::Checks::Redis do
  include Hcheck::Checks::Redis

  describe '#status' do
    let(:test_config) do
      {
        url: 'REDIS_DB_URL',
        db: 'REDIS_DB_NUM',
        password: 'REDIS_DB_PASSWORD'
      }
    end
    let(:redis_connection) { double('Redis', ping: 'pong') }

    before do
      allow(Redis).to receive(:new) { redis_connection }
    end

    subject { status(test_config) }

    it 'tries to make redis connection with supplied config' do
      expect(Redis).to receive(:new).with(test_config)
      expect(redis_connection).to receive(:ping)

      subject
    end

    context 'when hcheck is able to connect to redis with supplied config' do
      it 'returns ok' do
        expect(subject).to eql 'ok'
      end
    end

    context 'when hcheck is not able to connect to redis with supplied config' do
      it 'returns bad' do
        allow(redis_connection).to receive(:ping).and_raise(Redis::CannotConnectError)

        expect(subject).to eql 'bad'
      end
    end
  end
end
