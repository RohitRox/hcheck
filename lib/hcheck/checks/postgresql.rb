module Hcheck
  module Checks
    # postgresql check module
    # implements status
    # include postgresql check dependencies
    module Postgresql
      # @config { host, port, options, tty, dbname, user, password }
      def status(config)
        config[:user] = config.delete(:username) if config[:username]
        config[:dbname] = config.delete(:database) if config[:database]

        PG::Connection.new(config).close
        'ok'
      rescue PG::ConnectionBad => e
        Hcheck.logger.error "[HCheck] PG::ConnectionBad #{e.message}"
        'bad'
      end

      def self.included(_base)
        require 'pg'
      end
    end
  end
end
