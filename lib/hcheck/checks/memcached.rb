module Hcheck
  module Checks
    # memcached check module
    # implements status
    # include memcached check dependencies
    module Memcached
      # @config { hosts, user, password }
      def status(config)
        client = Dalli::Client.new(config.delete(:url), config)
        client.get('_')
        'ok'
      rescue Dalli::RingError => e
        Hcheck.logger.error "[HCheck] Memcached::Error::NoServerAvailable #{e.message}"
        'bad'
      end

      def self.included(_base)
        require 'dalli'
      end
    end
  end
end
