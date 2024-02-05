require 'spec_helper'

RSpec.describe Rider, type: :model do
  it 'is valid with valid attributes' do
    rider = build(:rider) # Assuming you have a rider factory
    expect(rider.valid?).to be
  end

  it 'is not valid without a name' do
    rider = build(:rider, name: nil) # Assuming you have a rider factory
    expect(rider.valid?).to be false
  end

  it 'is not valid without an email' do
    rider = build(:rider, email: nil)
    expect(rider.valid?).to be false
  end

  it 'is not valid without a current location' do
    rider = build(:rider, latitude: nil, longitude: nil)
    expect(rider.valid?).to be false
  end

  it 'is not valid with a duplicate email' do
    create(:rider, email: 'john@example.com')
    rider = build(:rider, email: 'john@example.com')
    expect(rider.valid?).to be false
  end
end
