require 'sinatra'
require 'sequel'
require 'dotenv'

# Carga las variables de entorno desde el archivo .env
Dotenv.load

# Conexión a la base de datos
require_relative 'database'

# Requiere los modelos
Dir[File.join(File.dirname(__FILE__), '../app/models', '*.rb')].each do |model|
  require model
end

# Requiere los controladores
Dir[File.join(File.dirname(__FILE__), '../app/controllers', '*.rb')].each do |controller|
  require controller
end

# Configuraciones adicionales de Sinatra u otros setups pueden ir aquí
