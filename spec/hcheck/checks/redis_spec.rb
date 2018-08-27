RSpec.describe 'Hcheck::Checks::Redis' do
  include Hcheck::Checks::Redis

  describe '#status' do
    let(:config) do
      {
        url: ENV['REDIS_DB_URL'],
        db: ENV['REDIS_DB_NUM'],
        password: ENV['REDIS_DB_PASSWORD']
      }
    end

    context 'when hcheck is able to connect to redis with supplied config' do
      it 'returns ok' do
        allow_any_instance_of(Redis).to receive(:ping).and_return('pong')
        expect(status(config)).to eql 'ok'
      end
    end

    context 'when hcheck is not able to connect to redis with supplied config' do
      let(:config) do
        {
          url: ENV['REDIS_DB_URL'],
          db: ENV['REDIS_DB'],
          password: ENV['REDIS_PASSWORD']
        }
      end
      it 'returns bad' do
        allow_any_instance_of(Redis).to receive(:ping).and_raise(Redis::CannotConnectError)
        expect(status(config)).to eql 'bad'
      end
    end
  end
end
