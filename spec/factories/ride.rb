require 'factory_bot'

FactoryBot.define do
  factory :ride do
    sequence(:id) { |n| n }
    association :rider
    association :driver
    start_location { "#{rider.latitude}, #{rider.longitude}" }
    end_location { "#{Faker::Address.latitude}, #{Faker::Address.longitude}" }
    distance_in_km { rand(1..100) }
    duration_in_minutes { rand(15..120) }
    cost { 3500 }
    status { 'active' }
    completed_at { nil }
  end
end
