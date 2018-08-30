module Hcheck
  module Checks
    # mysql check module
    # implements status
    # include mysql check dependencies
    module Mysql
      # @config { host, port, username, password, database }
      def status(config)
        connection = Mysql2::Client.new(config)
        connection.close
        'ok'
      rescue Mysql2::Error => e
        Hcheck.logger.error "[HCheck] Mysql2::Error::ConnectionError #{e.message}"
        'bad'
      end

      def self.included(_base)
        require 'mysql2'
      end
    end
  end
end
