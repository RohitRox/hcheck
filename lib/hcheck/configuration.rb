require 'logger'

require 'hcheck/configuration/service'
require 'hcheck/checks/postgresql'

module Hcheck
  # configuration class that loads configs via various ways
  # initializes service classes from config
  class Configuration
    attr_reader :services

    DEFAULT_CONFIG_PATH = "#{Dir.pwd}/hcheck.yml".freeze

    def initialize(config)
      @services = config.map do |key, options|
        Service.new(key, options)
      end
    end

    class << self
      def load(config)
        Hcheck.configure config
      end

      def load_argv(args)
        load_file(args[1].strip) if argv_config_present?(args)
      end

      def load_file(path)
        load yaml_load(path)
      end

      def load_default
        load_file(DEFAULT_CONFIG_PATH)
      end

      private

      def argv_config_present?(argvs)
        !argvs.empty? && argvs[0].match(/-+(config|c)/i)
      end

      def yaml_load(path)
        YAML.safe_load(ERB.new(File.read(path)).result) || {}
      end
    end
  end
end
