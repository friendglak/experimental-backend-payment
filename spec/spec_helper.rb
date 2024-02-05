require 'sequel'
require 'webmock/rspec'
require 'factory_bot'
require 'dotenv'
require 'database_cleaner/sequel'
require 'bundler/setup'

# Load environment variables
Dotenv.load

# Setup Bundler for test environment
Bundler.require(:default, :test)

# Connect to test database
TEST_DB = Sequel.connect(ENV['TEST_DATABASE_URL'])

# Require models
require_relative '../app/models/driver'
require_relative '../app/models/ride'
require_relative '../app/models/rider'

# Disable external requests, allow localhost
WebMock.disable_net_connect!(allow_localhost: true)

# Configure DatabaseCleaner to use Sequel and set the database
DatabaseCleaner[:sequel].db = TEST_DB

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  # Load all factory_bot definitions
  FactoryBot.find_definitions

  config.before(:suite) do
    # Clean the database before suite runs
    DatabaseCleaner[:sequel].clean_with(:truncation)
  end

  config.before(:each) do
    # Use transaction strategy and start before each test
    DatabaseCleaner[:sequel].strategy = :transaction
    DatabaseCleaner[:sequel].start
  end

  config.after(:each) do
    # Clean up after each test
    DatabaseCleaner[:sequel].clean
  end
end

# Adjust FactoryBot to use Sequel's `save` method
FactoryBot.define do
  to_create(&:save) # Simplified with Symbol to Proc
end
