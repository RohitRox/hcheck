module Hcheck
  module Checks
    # redis check module
    # implements status
    # include redis check dependencies
    module Redis
      # @config { host, port, db, password }
      def status(config)
        config[:sentinels] = config[:sentinels].map(&:symbolize_keys) if config[:sentinels]

        ::Redis.new(config).ping
        'ok'
      rescue ::Redis::CannotConnectError => e
        Hcheck.logger.error "[HCheck] Redis server unavailable #{e.message}"
        'bad'
      end

      def self.included(_base)
        require 'redis'
      end
    end
  end
end
