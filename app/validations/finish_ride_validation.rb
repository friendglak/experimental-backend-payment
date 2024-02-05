require 'dry-validation'

module Validations
  # Schema for the finish ride
  class FinishRideSchema < Dry::Validation::Contract
    params do
      required(:ride_id).filled(:int?)
    end
  end
end
