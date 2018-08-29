module Hcheck
  module Checks
    # mongodb check module
    # implements status
    # include mongodb check dependencies
    module Mongodb
      # @config { hosts }
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
