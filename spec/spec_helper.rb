require 'bundler/setup'
require 'pry'
require 'dotenv'

require 'hcheck'

Dotenv.load('spec/.env')

FIXTURE_HCHECK_FILE_PATH = "#{Dir.pwd}/spec/fixtures/hcheck.yml".freeze
INVALID_CONFIG_PATH = "#{Dir.pwd}/spec/fixtures/hcheck.invalid.yml".freeze

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
