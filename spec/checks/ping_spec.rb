RSpec.describe Hcheck::Checks::Ping do
  include Hcheck::Checks::Ping

  describe '#status' do
    let(:test_config) do
      {
        url: 'http://127.0.0.1/'
      }
    end
    let(:test_response) { Net::HTTPSuccess.new(1.0, 200, 'OK') }
    let(:test_request) { double('NET HTTP Request', request_head: test_response) }

    before do
      allow(Net::HTTP).to receive(:new) { test_request }
      allow(test_request).to receive(:read_timeout=)
    end

    let(:test_url) do
      URI.parse(test_config[:url])
    end

    subject { status(test_config) }

    it 'tries to make net http connection with supplied config' do
      expect(Net::HTTP).to receive(:new).with(test_url.host, test_url.port)

      subject
    end

    context 'when hcheck is able to ping and get a successful response' do
      it 'returns ok' do
        expect(test_request).to receive(:request_head).with(test_url.path)

        expect(subject).to eql 'ok'
      end
    end

    context 'when hcheck is not able to ping and get a successful response' do
      let(:test_response) { Net::HTTPInternalServerError.new(1.0, 500, 'Internal Server Error') }

      it 'returns bad' do
        expect(subject).to eql 'bad'
      end
    end
  end
end
