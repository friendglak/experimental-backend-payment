require 'sequel'
require 'dotenv/load'

DB = Sequel.connect(ENV['DATABASE_URL'], max_connections: 10)

DB_TEST = Sequel.connect(ENV['TEST_DATABASE_URL'], max_connections: 1)
