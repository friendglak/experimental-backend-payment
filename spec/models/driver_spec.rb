require 'spec_helper'

RSpec.describe Driver, type: :model do
  it 'is valid with valid attributes' do
    driver = build(:driver) # Asumiendo que tienes una fábrica para drivers
    expect(driver.valid?).to be true
  end

  it 'is not valid without a name' do
    driver = build(:driver, name: nil)
    expect(driver.valid?).to be false
  end

  it 'is not valid without an email' do
    driver = build(:driver, email: nil)
    expect(driver.valid?).to be false
  end

  it 'is not valid without a current location' do
    driver = build(:driver, latitude: nil, longitude: nil)
    expect(driver.valid?).to be false
  end

  it 'is not valid with a duplicate email' do
    create(:driver, email: 'john@example.com')
    driver = build(:driver, email: 'john@example.com')
    expect(driver.valid?).to be false
  end
end
