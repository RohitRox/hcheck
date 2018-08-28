module Hcheck
  module Checks
    # postgresql check module
    # implements status
    # include postgresql check dependencies
    module Mongodb
      # @config { host, port, options, tty, dbname, user, password }
      def status(config)
        hosts = config['hosts'].compact
        client = Mongo::Client.new(hosts, connect_timeout: 3, server_selection_timeout: hosts.count * 2)
        client.database_names
        client.close
        'ok'
      rescue Mongo::Error::NoServerAvailable => e
        client.close
        Hcheck.logger.error "[HCheck] Mongo::Error::NoServerAvailable #{e.message}"
        'bad'
      end

      def self.included(_base)
        require 'mongo'
        Mongo::Logger.level = Logger::INFO
      end
    end
  end
end
