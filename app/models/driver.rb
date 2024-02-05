require 'sequel'

# Model for the drivers table.
class Driver < Sequel::Model
  plugin :validation_helpers

  def validate
    super
    validates_presence %i[name email latitude longitude available], message: 'is required'
    validates_unique :email, message: 'is already taken'
  end
end
