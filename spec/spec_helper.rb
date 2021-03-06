# frozen_string_literal: true

require 'bundler/setup'
require 'pry'
require 'dotenv'

require 'hcheck'

Dotenv.load('spec/.env')

FIXTURE_HCHECK_FILE_PATH = 'spec/fixtures/hcheck.yml'
INVALID_CONFIG_PATH = 'spec/fixtures/hcheck.invalid.yml'

Dir.glob('./spec/support/**/*.rb').each { |f| require f }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.exclude_pattern = './spec/support/**/*.rb'
end
