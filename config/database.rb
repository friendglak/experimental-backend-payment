require 'sequel'
require 'dotenv/load'

DB = Sequel.connect(ENV['DATABASE_URL'], max_connections: 10)
