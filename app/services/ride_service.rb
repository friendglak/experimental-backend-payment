require 'sequel'
require_relative '../models/driver'
require_relative '../models/ride'

# Class to handle ride-related logic, such as assigning drivers and calculating ride costs.
class RideService
  def self.assign_driver(_latitude, _longitude, _destination)
    driver = Driver.where(available: true).first
    # Lanza una excepción si no hay conductores disponibles.
    raise StandardError, 'No drivers available' unless driver

    driver
  end

  def self.calculate_ride_cost(ride)
    base_fare = 3500 # Tarifa base en COP.
    cost_per_km = 1000 # Costo por kilómetro en COP.
    cost_per_minute = 200 # Costo por minuto en COP.

    # Asegura que la instancia de Ride tenga las propiedades necesarias.
    unless ride.distance_in_km && ride.duration_in_minutes
      raise StandardError, 'Ride lacks necessary distance or duration information.'
    end

    # Calcula el costo total basado en la distancia, duración, y tarifas.
    total_cost = base_fare + (ride.distance_in_km * cost_per_km) + (ride.duration_in_minutes * cost_per_minute)

    total_cost
  end
end
