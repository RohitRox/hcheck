module Hcheck
  module Checks
    # mongodb check module
    # implements status
    # include mongodb check dependencies
    module Mongodb
      # @config { hosts, user, password }
      def status(config)
        mongo_config = config.merge(connect_timeout: 3)
        hosts = mongo_config.delete(:hosts).compact
        client = Mongo::Client.new(hosts, mongo_config.merge(server_selection_timeout: hosts.count * 2))
        client.database_names
        client.close
        'ok'
      rescue Mongo::Error::NoServerAvailable => e
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
