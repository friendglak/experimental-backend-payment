require 'dry-validation'

module Validations
  # Schema for the ride request
  class RideRequestSchema < Dry::Validation::Contract
    params do
      required(:longitude).filled(:float?)
      required(:latitude).filled(:float?)
      optional(:destination).filled(:str?)
    end
  end
end
