require 'factory_bot'

FactoryBot.define do
  factory :rider do
    sequence(:id) { |n| n }
    name { 'Juan Camilo Velasquez Amarillo' }
    sequence :email do |n|
      "rider#{n}@example.com"
    end
    latitude { 4.710989 } # Ejemplo con Bogotá, Colombia
    longitude { -74.072092 }
  end
end
