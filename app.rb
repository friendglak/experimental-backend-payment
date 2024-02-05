require_relative 'config/environment'
require_relative 'app/controllers/riders_controller'
require_relative 'app/controllers/drivers_controller'

# Class to handle the main application
class RideHailingApp < Sinatra::Base
  set :bind, '0.0.0.0'
  # Configuraciones de Sinatra, como sesiones, middleware, etc.
  configure :production do
    set :logging, Logger::INFO
  end

  use RidersController
  use DriversController

  get '/' do
    'Bienvenido a la API de Servicio de Transporte'
  end

  run! if app_file == $0
end
