require 'rack/test'

RSpec.describe Hcheck::Application do
  include Rack::Test::Methods

  require 'pg'

  ORIGINAL_CONFIG = Hcheck::Configuration::DEFAULT_CONFIG_PATH

  before do
    ENV['HCHECK_SECURE'] = nil
    Hcheck::Configuration::DEFAULT_CONFIG_PATH = FIXTURE_HCHECK_FILE_PATH
  end

  after(:all) do
    ENV['HCHECK_SECURE'] = "true"
    Hcheck::Configuration::DEFAULT_CONFIG_PATH = ORIGINAL_CONFIG
  end

  context "GET /" do
    context 'config is good to go' do
      def app
        Hcheck::Status.new
      end

      context 'all checks pass' do
        it "displays Ok status page with 2xx status code" do
          allow(PG::Connection).to receive(:new) { double(:connection, close: true) }

          get '/'

          expect(last_response.body).to include("Hcheck Status Page")
          expect(last_response.body).to include("Core Store")
          expect(last_response.body).to include("Ok")
          expect(last_response.status).to eql 200
        end
      end

      context 'one of the a check fails' do
        it "displays Bad status page with 5xx status code" do
          allow(PG::Connection).to receive(:new).and_raise(PG::ConnectionBad)

          get '/'

          expect(last_response.body).to include("Hcheck Status Page")
          expect(last_response.body).to include("Core Store")
          expect(last_response.body).to include("Bad")
          expect(last_response.status).to eql 503
        end
      end

      context 'secure path' do
        context 'secured path is activated but token is not setup' do
          it 'displays config error with 4xx response' do
            ENV['HCHECK_SECURE'] = "true"

            get '/'

            expect(last_response.body).to include(Hcheck::Errors::IncompleteAuthSetup::MSG)
            expect(last_response.status).to eql 401
          end
        end

        context 'secured path is activated with token' do
          before do
            ENV['HCHECK_SECURE'] = "true"
            ENV['HCHECK_ACCESS_TOKEN'] = "blah"

            allow(PG::Connection).to receive(:new) { double(:connection, close: true) }
          end

          after(:all) do
            ENV['HCHECK_ACCESS_TOKEN'] = nil
          end

          context "token is valid" do
            it 'displays status page with 2xx response' do
              get '/?token=blah'

              expect(last_response.body).to include("Hcheck Status Page")
              expect(last_response.status).to eql 200
            end
          end

          context "token is not present" do
            it 'displays auth error with 4xx response' do
              get '/'

              expect(last_response.body).to include(Hcheck::Errors::InvalidAuthentication::MSG)
              expect(last_response.status).to eql 401
            end
          end

          context "token is not valid" do
            it 'displays auth error with 4xx response' do
              get '/?token=xxx'

              expect(last_response.body).to include(Hcheck::Errors::InvalidAuthentication::MSG)
              expect(last_response.status).to eql 401
            end
          end
        end
      end
    end

    context 'bad config' do
      after(:all) do
        Hcheck::Configuration::DEFAULT_CONFIG_PATH = ORIGINAL_CONFIG
      end

      context 'malformed config' do
        def app
          Hcheck::Status.new
        end

        before do
          Hcheck::Configuration::DEFAULT_CONFIG_PATH = INVALID_CONFIG_PATH
        end

        it 'display config error with 5xx response' do
          get '/'

          expect(last_response.body).to include(Hcheck::Errors::ConfigurationError::MSG)
          expect(last_response.status).to eql 500
        end
      end

      context 'config not present' do
        def app
          Hcheck::Status.new
        end

        before do
          Hcheck::Configuration::DEFAULT_CONFIG_PATH = 'some/random/path.yml'
        end

        it 'display config error with 5xx response' do
          get '/'

          expect(last_response.body).to include(Hcheck::Errors::ConfigurationError::MSG)
          expect(last_response.status).to eql 500
        end
      end
    end
  end
end
