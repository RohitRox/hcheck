# frozen_string_literal: true

# find and require all check modules
Gem.find_files('hcheck/checks/*.rb').each do |check_file|
  require "hcheck/checks/#{File.basename(check_file)}"
end

module Hcheck
  class Configuration
    # Main service class
    # One to one servcie class is created from hcheck.yml top level keys
    # includes corresponsing check module; which includes status method
    class Service
      attr_reader :name, :check_not_available

      NOT_IMPLEMENTED_MSG = 'Check not implemented for this service'

      def initialize(service, options)
        @name = service.to_s
        @check = options.delete('check')
        @options = options.symbolize_keys
        if mod = load_mod
          singleton_class.send(:include, mod)
        else
          @check_not_available = true
        end
      end

      def check
        {
          name: @name,
          desc: @check,
          status: @check_not_available ? NOT_IMPLEMENTED_MSG : status(@options)
        }
      end

      private

      def load_mod
        Hcheck::Checks.const_get(@name.capitalize)
      rescue NameError
        nil
      end
    end
  end
end
