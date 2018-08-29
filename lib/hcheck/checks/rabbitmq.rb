require 'pry'
module Hcheck
  module Checks
    # rabbitmq check module
    # implements status
    # include rabbitmq check dependencies
    module Rabbitmq
      # @config { host, vhost, port, user, pass }
      def status(config)
        connection = Bunny.new(config)
        connection.start
        connection.close
        'ok'
      rescue Bunny::TCPConnectionFailed,
             Bunny::TCPConnectionFailedForAllHosts,
             Bunny::NetworkFailure,
             Bunny::AuthenticationFailureError,
             Bunny::PossibleAuthenticationFailureError => e
        Hcheck.logger.error "[HCheck] Bunny::Error #{e.message}"
        'bad'
      end

      def self.included(_base)
        require 'bunny'
      end
    end
  end
end
