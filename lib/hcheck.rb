require 'yaml'
require 'erb'
require 'logger'

require 'hcheck/version'
require 'hcheck/helpers'
require 'hcheck/application'
require 'hcheck/configuration'

# Main Hcheck module
module Hcheck
  class << self
    attr_accessor :configuration, :logging

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
  end

  LOG_FILE_PATH = 'log/hcheck.log'

  def self.configure(config = {})
    self.configuration ||= Configuration.new(config)
  end

  def self.logger
    self.logging ||= self.set_logger
  end

  def self.set_logger
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
