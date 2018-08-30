RSpec.describe 'Hcheck::Checks::Mongodb' do
  include Hcheck::Checks::Mongodb

  describe '#status' do
    let(:config) do
      {
        hosts: ['MONGO_DB_HOST', nil]
      }
    end
    let(:connection) { double('Mongo::Client', database_names: [], close: true) }

    before do
      allow(Mongo::Client).to receive(:new) { connection }
    end

    subject { status(config) }

    it 'tries to make mongo connection with supplied config (removes nil hosts) with additional config' do
      hosts = config[:hosts].compact
      expect(Mongo::Client).to receive(:new).with(hosts,
                                                  connect_timeout: 3,
                                                  server_selection_timeout: hosts.count * 2)

      subject
    end

    context 'when hcheck is able to connect to mongo with supplied config' do
      it 'returns ok' do
        expect(subject).to eql 'ok'
      end
    end

    context 'when mongo servers are not reachable' do
      it 'returns bad' do
        server_selector_object = double(:server_selector, server_selection_timeout: 1, local_threshold: 1)
        allow(connection).to receive(:database_names).and_raise Mongo::Error::NoServerAvailable, server_selector_object

        expect(subject).to eql 'bad'
      end
    end
  end
end
