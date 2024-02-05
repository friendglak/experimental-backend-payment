require 'sequel'

# Model for the Ride table.
class Ride < Sequel::Model
  many_to_one :rider
  many_to_one :driver

  def validate
    super
    errors.add(:start_location, 'cannot be empty') if start_location.nil? || start_location.empty?
    errors.add(:rider_id, 'cannot be empty') unless rider
    errors.add(:driver_id, 'cannot be empty') unless driver
  end
end
