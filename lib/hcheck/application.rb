require 'sinatra'
require 'haml'

require 'hcheck'
require 'hcheck/application/helpers/responders'

module Hcheck
  # base sinatra application
  class Base < Sinatra::Base
    set :public_dir, File.expand_path('application/assets', __dir__)
    set :views, File.expand_path('application/views', __dir__)
    set :haml, format: :html5

    include Hcheck::ApplicationHelpers::Responders
  end

  # sinatra that gets booted when run in standalone mode
  class Application < Base
    get('/hcheck') { h_status }
  end

  # sinatra when mounted to rails
  class Status < Base
    def initialize(app = nil)
      Hcheck::Configuration.load_default
    rescue Hcheck::Errors::ConfigurationError => e
      @config_error = e
    ensure
      super(app)
    end

    get('/') do
      if @config_error
        Hcheck.logger.error @config_error.message

        respond_with Hcheck::Errors::ConfigurationError::MSG, 500, :error
      else
        h_status
      end
    end
  end
end
