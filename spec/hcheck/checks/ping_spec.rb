RSpec.describe Hcheck::Checks::Ping do
  include Hcheck::Checks::Ping

  describe '#status' do
    let(:config) do
      {
        url: 'http://127.0.0.1/'
      }
    end
    let(:request) { double('NET HTTP Request') }
    let(:response) { Net::HTTPSuccess.new(1.0, 200, 'OK') }

    before do
      allow(request).to receive(:read_timeout=)
      allow(request).to receive(:request_head){ response }
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

    context 'when hcheck is able to ping and get a successful response' do
      it 'returns ok' do
        expect(subject).to eql 'ok'
      end
    end

    context 'when hcheck is not able to ping and get a successful response' do
      let(:response){ Net::HTTPInternalServerError.new(1.0, 500, 'Internal Server Error') }

      it 'returns bad' do
        expect(subject).to eql 'bad'
      end
    end
  end
end
