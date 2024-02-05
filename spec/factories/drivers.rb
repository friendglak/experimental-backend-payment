require 'factory_bot'

FactoryBot.define do
  factory :driver do
    sequence(:id) { |n| n }
    name { 'Alejandro Ospina' }
    sequence :email do |n|
      "driver#{n}@example.com"
    end
    available { true }
    latitude { 4.710989 } # Ejemplo con Bogotá, Colombia
    longitude { -74.072092 }
  end
end
