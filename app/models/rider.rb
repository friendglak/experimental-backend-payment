require 'sequel'

# Model for the riders table.
class Rider < Sequel::Model
  plugin :validation_helpers

  def validate
    super
    validates_presence %i[name email latitude longitude], message: 'is required'
    validates_unique :email, message: 'is already taken'
  end
end
