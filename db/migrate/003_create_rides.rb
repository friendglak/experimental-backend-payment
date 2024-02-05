Sequel.migration do
  up do
    create_table(:rides) do
      primary_key :id
      foreign_key :rider_id, :riders, null: false
      foreign_key :driver_id, :drivers, null: false
      String :start_location, text: true, null: false
      String :end_location, text: true, null: false
      Float :distance_in_km # Distancia del viaje en kilómetros
      Integer :duration_in_minutes # Duración del viaje en minutos
      Numeric :cost, size: [10, 2] # Costo del viaje
      DateTime :completed_at # Fecha y hora de cuando se completó el viaje
      String :status, default: 'pending', null: false
      DateTime :created_at
      DateTime :updated_at
    end
  end

  down do
    drop_table(:rides)
  end
end
