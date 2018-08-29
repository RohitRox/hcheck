RSpec.describe Hcheck::Checks::Ping do
  include Hcheck::Checks::Ping

  describe '#status' do
    let(:config) do
      {
        url: 'http://127.0.0.1/'
      }
    end
    let(:request) { double('NET HTTP Request', request_head: true) }

    before do
      allow(request).to receive(:read_timeout=)
      allow(Net::HTTP).to receive(:new) { request }
    end

    let(:url) do
      URI.parse(config[:url])
    end

    subject { status(config) }

    it 'tries to make net http connection with supplied config' do
      expect(Net::HTTP).to receive(:new).with(url.host, url.port)
      expect(request).to receive(:request_head).with(url.path)

      subject
    end

  #   context 'when hcheck is able to connect to postgres with supplied config' do
  #     it 'returns ok' do
  #       expect(subject).to eql 'ok'
  #     end
  #   end

  #   context 'when hcheck is not able to connect to postgres with supplied config' do
  #     before do
  #       allow(PG::Connection).to receive(:new).and_raise(PG::ConnectionBad)
  #     end

  #     it 'returns bad' do
  #       expect(subject).to eql 'bad'
  #     end
  #   end
  end
end
