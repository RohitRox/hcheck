require 'pry'
module Hcheck
  module Errors
    class HcheckError < StandardError
      MSG = 'Hcheck standard error'
      def initialize(msg = nil)
        message = msg || self.class::MSG
        Hcheck.logger.error message
        super(message)
      end
    end

    class InvalidAuthentication < HcheckError
      MSG = "Invalid authenticity token!"
    end

    class IncompleteAuthSetup < HcheckError
      MSG="Incomplete auth setup in HCheck server"
    end

    class ConfigurationError < HcheckError
      MSG="Hcheck configuration cannot not be found or read"

      def initialize(e)
        super("#{MSG}\n#{e.class}\n#{e.message}")
      end
    end
  end
end