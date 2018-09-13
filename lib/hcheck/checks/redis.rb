module Hcheck
  module Checks
    # redis check module
    # implements status
    # include redis check dependencies
    module Redis
      # @config { host, port, db, password }
      def status(config)
        if config[:sentinels]
          config[:sentinels] = config[:sentinels].map(&:symbolize_keys)
        end

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
