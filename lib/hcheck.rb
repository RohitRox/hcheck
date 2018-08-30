require 'yaml'
require 'erb'
require 'logger'

require 'hcheck/version'
require 'hcheck/helper'
require 'hcheck/application'
require 'hcheck/configuration'

# Main Hcheck module
module Hcheck
  class << self
    attr_accessor :configuration, :logging

    LOG_FILE_PATH = 'log/hcheck.log'

    def status
      if configuration
        configuration.services.map(&:check)
      else
        [{
          service: 'hcheck',
          status: 'Hcheck configuration not found'
        }]
      end
    end

    def configure(config = {})
      self.configuration ||= Configuration.new(config)
    end

    def logger(_config = {})
      self.logging ||= Logger.new(STDOUT)
    end

    def logger
      self.logging ||= set_logger
    end

    private

    def set_logger
      dir = File.dirname(LOG_FILE_PATH)
      FileUtils.mkdir_p(dir) unless File.directory?(dir)
      logger = Logger.new(LOG_FILE_PATH, 'daily')
      logger.formatter = proc do |severity, datetime, progname, msg|
        log_msg = "[#{severity}] [#{datetime}] #{msg}"
        puts log_msg
        log_msg
      end
      logger
    end
  end
end
