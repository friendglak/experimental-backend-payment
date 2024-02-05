require 'spec_helper'

RSpec.describe Ride, type: :model do
  it 'is valid with valid attributes' do
    ride = build(:ride)
    expect(ride.valid?).to be true
  end

  it 'is not valid without a start_location' do
    ride = build(:ride, start_location: nil)
    expect(ride.valid?).to be false
  end

  it 'is not valid without a rider' do
    ride = build(:ride, rider: nil, start_location: "0.0, 0.0")
    expect(ride.valid?).to be false
  end

  it 'is not valid without a driver' do
    ride = build(:ride, driver: nil)
    expect(ride.valid?).to be false
  end

  # Agrega más pruebas según sea necesario
end
