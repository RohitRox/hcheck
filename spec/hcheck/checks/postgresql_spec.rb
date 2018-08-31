RSpec.describe Hcheck::Checks::Postgresql do
  include Hcheck::Checks::Postgresql

  describe '#status' do
    let(:config) do
      {
        host: 'PG_DB_HOST',
        dbname: 'PG_DBNAME',
        user: 'PG_DB_USER',
        password: 'PG_DB_PASSWORD'
      }
    end
    let(:connection) { double('PG::Connection', close: true) }

    before do
      allow(PG::Connection).to receive(:new) { connection }
    end

    subject { status(config) }

    it 'tries to make pg connection with supplied config' do
      expect(PG::Connection).to receive(:new).with(config)

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
