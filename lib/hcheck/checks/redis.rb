module Hcheck
  module Checks
    # redis check module
    # implements status
    # include redis check dependencies
    module Redis
      # @config { host, port, db, password }
      def status(config)
        ::Redis.new(config).ping
        'ok'
      rescue ::Redis::CannotConnectError => e
        puts "[HCheck] Redis server unavailable #{e.message}"
        'bad'
      end

      def self.included(_base)
        require 'redis'
      end
    end
  end
end
