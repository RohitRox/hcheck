RSpec.describe Hcheck::Checks::Mysql do
  include Hcheck::Checks::Mysql

  describe '#status' do
    let(:test_config) do
      {
        host: 'MYSQL_DB_HOST',
        user: 'MYSQL_DB_USER',
        password: ''
      }
    end
    let(:mysql_connection) { double('Mysql2::Client', close: true) }

    before do
      allow(Mysql2::Client).to receive(:new) { mysql_connection }
    end

    subject { status(test_config) }

    it 'tries to make mysql connection with supplied config' do
      expect(Mysql2::Client).to receive(:new).with(test_config)

      subject
    end

    context 'when hcheck is able to connect to mysql with supplied config' do
      it 'returns ok' do
        expect(subject).to eql 'ok'
      end
    end

    context 'when hcheck is not able to connect to mysql with supplied config' do
      before do
        mysql_error_obj = double(:error, encode: true)
        allow(Mysql2::Client).to receive(:new).and_raise(Mysql2::Error, mysql_error_obj)
      end

      it 'returns bad' do
        expect(subject).to eql 'bad'
      end
    end
  end
end
