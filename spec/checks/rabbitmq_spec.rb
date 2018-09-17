RSpec.describe Hcheck::Checks::Rabbitmq do
  include Hcheck::Checks::Rabbitmq

  describe '#status' do
    let(:test_config) do
      {
        host: 'RABBIT_HOST',
        user: 'RABBIT_USER',
        pass: 'RABBIT_PASS'
      }
    end
    let(:bunny_connection) { double('Bunny', start: true, close: true) }

    before do
      allow(Bunny).to receive(:new) { bunny_connection }
    end

    subject { status(test_config) }

    it 'tries to make rabbitmq connection with supplied config' do
      expect(Bunny).to receive(:new).with(test_config)
      expect(bunny_connection).to receive(:start)
      expect(bunny_connection).to receive(:close)

      subject
    end

    context 'when hcheck is able to connect to rabbitmq with supplied config' do
      it 'returns ok' do
        expect(subject).to eql 'ok'
      end
    end

    context 'when hcheck is not able to connect to rabbitmq with supplied config' do
      before do
        allow(Bunny).to receive(:new).and_raise Bunny::NetworkFailure.new(nil, nil)
      end

      it 'returns bad' do
        expect(subject).to eql 'bad'
      end
    end
  end
end
