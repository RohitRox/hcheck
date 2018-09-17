RSpec.describe Hcheck::Checks::Postgresql do
  include Hcheck::Checks::Postgresql

  describe '#status' do
    let(:test_config) do
      {
        host: 'PG_DB_HOST',
        dbname: 'PG_DBNAME',
        user: 'PG_DB_USER',
        password: 'PG_DB_PASSWORD'
      }
    end
    let(:pg_connection) { double('PG::Connection', close: true) }

    before do
      allow(PG::Connection).to receive(:new) { pg_connection }
    end

    subject { status(test_config) }

    it 'tries to make pg connection with supplied config' do
      expect(PG::Connection).to receive(:new).with(test_config)

      subject
    end

    context 'when hcheck is able to connect to postgres with supplied config' do
      it 'returns ok' do
        expect(subject).to eql 'ok'
      end
    end

    context 'when hcheck is not able to connect to postgres with supplied config' do
      before do
        allow(PG::Connection).to receive(:new).and_raise(PG::ConnectionBad)
      end

      it 'returns bad' do
        expect(subject).to eql 'bad'
      end
    end
  end
end
