require 'sinatra'
require 'haml'

require 'hcheck'

module Hcheck
  # base sinatra application
  class Base < Sinatra::Base
    set :public_dir, File.expand_path('application/assets', __dir__)
    set :views, File.expand_path('application/views', __dir__)
    set :haml, format: :html5

    helpers do
      def h_status
        @status = Hcheck.status

        if @status.find { |s| s[:status] == 'bad' }
          status 503
        else
          status 200
        end

        haml :index
      end
    end
  end

  # sinatra that gets booted when run in standalone mode
  class Application < Base
    get('/hcheck') { h_status }
  end

  # sinatra when mounted to rails
  class Status < Base
    def initialize(app = nil)
      Hcheck::Configuration.load_default
      super(app)
    end

    get('/') { h_status }
  end
end
