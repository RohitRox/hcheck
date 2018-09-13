# frozen_string_literal: true

require 'logger'

require 'hcheck/configuration/service'

module Hcheck
  # configuration class that loads configs via various ways
  # initializes service classes from config
  class Configuration
    attr_reader :services

    DEFAULT_CONFIG_PATH = "#{Dir.pwd}/hcheck.yml"

    def initialize(config)
      @services = config.map do |key, options|
        options = [options] unless options.is_a?(Array)
        options.map { |o| Service.new(key, o) }
      end.flatten
    end

    class << self
      def load(config)
        Hcheck.configure config
      end

      def load_argv(args)
        load_file(args[1].strip) if argv_config_present?(args)
      end

      def load_file(path)
        load read(path)
      end

      def load_default
        load_file(DEFAULT_CONFIG_PATH)
      end

      def read(path)
        YAML.safe_load(ERB.new(File.read(path)).result, [Symbol]) || {}
      rescue StandardError => e
        raise Hcheck::Errors::ConfigurationError, e
      end

      private

      def argv_config_present?(argvs)
        !argvs.empty? && argvs[0].match(/-+(config|c)/i)
      end
    end
  end
end
