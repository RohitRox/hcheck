module Hcheck
  module Errors
    # Hcheck standard error class
    class HcheckError < StandardError
      MSG = 'Hcheck standard error'.freeze

      def initialize(msg = nil)
        message = msg || self.class::MSG
        Hcheck.logger.error message
        super(message)
      end
    end

    class InvalidAuthentication < HcheckError
      MSG = 'Invalid authenticity token!'.freeze
    end

    class IncompleteAuthSetup < HcheckError
      MSG = 'Incomplete auth setup in HCheck server'.freeze
    end

    class ConfigurationError < HcheckError
      MSG = 'Hcheck configuration cannot not be found or read'.freeze

      def initialize(err)
        super("#{MSG}\n#{err.class}\n#{err.message}")
      end
    end
  end
end
