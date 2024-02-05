require 'sequel'
require 'webmock/rspec'
require 'factory_bot'
require 'bundler/setup'
require 'dotenv'
require 'database_cleaner/sequel'

Dotenv.load

Bundler.require(:default, :test)

TEST_DB = Sequel.connect(ENV['TEST_DATABASE_URL'])
require_relative '../app/models/driver'
require_relative '../app/models/ride'
require_relative '../app/models/rider'

WebMock.disable_net_connect!(allow_localhost: true)

DatabaseCleaner[:sequel].db = Sequel.connect("postgres://postgres:friendglak@localhost/ride_hailing_service_test")

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  FactoryBot.find_definitions

  config.before(:suite) do
    DatabaseCleaner[:sequel].clean_with(:truncation)
  end

  # Establece la estrategia de limpieza como transacción por defecto
  config.before(:each) do
    DatabaseCleaner[:sequel].strategy = :transaction
  end

  # Inicia la limpieza antes de cada prueba
  config.before(:each) do
    DatabaseCleaner[:sequel].start
  end

  # Limpia la base de datos después de cada prueba
  config.after(:each) do
    DatabaseCleaner[:sequel].clean
  end
end

# Si tienes un bloque de configuración para tus fábricas, ajusta el método de guardado
FactoryBot.define do
  to_create {|instance| instance.save } # Usa `save` de Sequel en lugar de `save!`
end
