# frozen_string_literal: true

RSpec.describe Hcheck::Status do
  it_behaves_like Hcheck::ApplicationHelpers::Responders do
    before do
      Hcheck::Configuration::DEFAULT_CONFIG_PATH = FIXTURE_HCHECK_FILE_PATH
    end

    let(:application) do
      Hcheck::Status.new
    end

    let(:path) { '/' }

    context 'bad config' do
      ORIGINAL_CONFIG = Hcheck::Configuration::DEFAULT_CONFIG_PATH

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
          get path

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
          get path

          expect(last_response.body).to include(Hcheck::Errors::ConfigurationError::MSG)
          expect(last_response.status).to eql 500
        end
      end
    end
  end
end
