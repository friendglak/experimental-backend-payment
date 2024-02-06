require_relative '../services/payment_service'
require_relative '../models/rider'

# Service to handle rider-related logic, such as adding payment methods.
class RiderService
  def self.add_payment_method(rider_id, payment_token, customer_email)
    response = PaymentService.create_payment_source(rider_id, payment_token, customer_email)

    if response.key?(:error)
      puts response[:error]
    else
      rider = Rider.find(id: rider_id)
      if rider
        rider.update(payment_source_id: response['data']['id'])
        puts "Payment source created and stored successfully for rider #{rider_id}"
      else
        puts 'Rider not found'
        return { error: 'Rider not found' }.to_json, status: 404
      end
    end
  end
end
