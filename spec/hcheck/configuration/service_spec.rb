RSpec.describe Hcheck::Configuration::Service do
  let(:service_name) { 'postgresql' }
  let(:subject) { Hcheck::Configuration::Service.new(service_name, host: 'localhost') }

  describe '#initialize' do
    context 'when check is implemented' do
      it 'inlcudes the check module' do
        expect(Hcheck::Configuration::Service).to receive(:include).with(Hcheck::Checks::Postgresql)

        subject
      end
    end

    context 'when check is not yet implemented' do
      let(:service_name) { 'unknown' }

      it 'sets check_not_available flag to true' do
        expect(subject.check_not_available).to eql(true)
      end
    end
  end

  describe '#check' do
    context 'when check is available' do
      let(:service_status) { 'status' }

      it 'returns status of the service check' do
        subject
        allow(subject).to receive(:status) { service_status }

        expect(subject.check).to eql(
          name: service_name,
          status: service_status
        )
      end
    end

    context 'when check is not available' do
      let(:service_name) { 'unknown' }

      it 'returns not implemented status' do
        expect(subject.check).to eql(
          name: service_name,
          status: Hcheck::Configuration::Service::NOT_IMPLEMENTED_MSG
        )
      end
    end
  end
end
