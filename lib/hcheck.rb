require 'yaml'
require 'erb'

require 'hcheck/version'
require 'logger'

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

  def self.configure(config = {})
    self.configuration ||= Configuration.new(config)
  end

  def self.logger(_config = {})
    self.logging ||= Logger.new(STDOUT)
  end
end
