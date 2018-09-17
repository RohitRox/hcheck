RSpec.shared_examples Hcheck::ApplicationHelpers::Responders do
  require 'pg'
  require 'rack/test'

  include Rack::Test::Methods

  def app
    application
  end

  before do
    ENV['HCHECK_SECURE'] = nil
  end

  after(:all) do
    ENV['HCHECK_SECURE'] = 'true'
  end

  context 'all checks pass' do
    it 'displays Ok status page with 2xx status code' do
      allow(PG::Connection).to receive(:new) { double(:connection, close: true) }

      get path

      expect(last_response.body).to include('Hcheck Status Page')
      expect(last_response.body).to include('Core Store')
      expect(last_response.body).to include('Ok')
      expect(last_response.status).to eql 200
    end
  end

  context 'secure path' do
    context 'secured path is activated but token is not setup' do
      it 'displays config error with 4xx response' do
        ENV['HCHECK_SECURE'] = 'true'

        get path

        expect(last_response.body).to include(Hcheck::Errors::IncompleteAuthSetup::MSG)
        expect(last_response.status).to eql 401
      end
    end

    context 'secured path is activated with token' do
      before do
        ENV['HCHECK_SECURE'] = 'true'
        ENV['HCHECK_ACCESS_TOKEN'] = 'blah'

        allow(PG::Connection).to receive(:new) { double(:connection, close: true) }
      end

      after(:all) do
        ENV['HCHECK_ACCESS_TOKEN'] = nil
      end

      context 'token is valid' do
        it 'displays status page with 2xx response' do
          get "#{path}?token=blah"

          expect(last_response.body).to include('Hcheck Status Page')
          expect(last_response.status).to eql 200
        end
      end

      context 'token is not present' do
        it 'displays auth error with 4xx response' do
          get path

          expect(last_response.body).to include(Hcheck::Errors::InvalidAuthentication::MSG)
          expect(last_response.status).to eql 401
        end
      end

      context 'token is not valid' do
        it 'displays auth error with 4xx response' do
          get "#{path}?token=xxx"

          expect(last_response.body).to include(Hcheck::Errors::InvalidAuthentication::MSG)
          expect(last_response.status).to eql 401
        end
      end
    end
  end
end
