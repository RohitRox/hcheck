RSpec.describe Hcheck::Checks::Postgresql do
  include Hcheck::Checks::Postgresql

  describe '#status' do
    let(:config) do
      {
        host: ENV['PG_DB_HOST'],
        dbname: ENV['PG_DBNAME'],
        user: ENV['PG_DB_USER'],
        password: ENV['PG_DB_PASSWORD']
      }
    end

    context 'when hcheck is able to connect to postgres with supplied config' do
      before do
        connection = double(PG::Connection)
        allow(PG).to receive(:connect).and_return(connection)
        allow(connection).to receive(:close).and_return(true)
      end

      it 'returns ok' do
        expect(status(config)).to eql 'ok'
      end
    end

    context 'when hcheck is not able to connect to postgres with supplied config' do
      let(:config) do
        {
          host: 'nowhere',
          dbname: ENV['PG_DBNAME'],
          user: ENV['PG_DB_USER'],
          password: ENV['PG_DB_PASSWORD']
        }
      end
      before do
        connection = double(PG::Connection)
        allow(PG).to receive(:connect).and_return(connection)
        allow(connection).to receive(:close).and_raise(PG::ConnectionBad)
      end

      it 'returns bad' do
        expect(status(config)).to eql 'bad'
      end
    end
  end
end
