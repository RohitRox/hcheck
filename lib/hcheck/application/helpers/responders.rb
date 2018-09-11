module Hcheck
  module ApplicationHelpers
    module Responders
      extend self

      def h_status
        authenticate!(params) if secured_access_enabled?

        @status = Hcheck.status

        if @status.find { |s| s[:status] == 'bad' }
          status 503
        else
          status 200
        end

        haml :index
      rescue Hcheck::Errors::InvalidAuthentication, Hcheck::Errors::IncompleteAuthSetup  => e
        status 401
        @msg = e.message

        haml :error
      end

      def respond_with(message, status_code, view)
        status status_code
        @msg = message

        haml view
      end

      private

      def secured_access_enabled?
        ENV['HCHECK_SECURE']
      end

      def authenticate!(params)
        @token = params[:token]
        access_precheck!

        raise Hcheck::Errors::InvalidAuthentication unless ENV['HCHECK_ACCESS_TOKEN'].eql?(@token)
      end

      def access_precheck!
        # throw error when hcheck secure is enabled but token is not set yet
        raise Hcheck::Errors::IncompleteAuthSetup unless ENV['HCHECK_ACCESS_TOKEN'].present?

        # throw error when token is not sent
        raise Hcheck::Errors::InvalidAuthentication unless @token.present?
      end
    end
  end
end
