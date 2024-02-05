require 'dry-validation'

module Validations
  # Schema for the payment method
  class PaymentMethodSchema < Dry::Validation::Contract
    params do
      required(:type).filled(:str?).value(included_in?: ['CARD'])
      required(:token).filled(:str?)
      required(:acceptance_token).filled(:str?)
      required(:customer_email).filled(:str?, format?: /@/)
    end
  end
end
