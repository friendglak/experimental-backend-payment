require 'sinatra/base'
require 'json'
require_relative '../services/ride_service'
require_relative '../services/payment_service'

# Controller to handle driver actions
class DriversController < Sinatra::Base
  post '/drivers/:id/finish_ride' do
    content_type :json
    begin
      request_payload = JSON.parse(request.body.read)
      ride_id = request_payload['ride_id']
      ride = Ride[ride_id]

      if ride.nil?
        status 404
        return { error: 'Ride not found' }.to_json
      end

      if ride.driver_id.to_i != params[:id].to_i
        status 403
        return { error: 'Driver not associated with this ride' }.to_json
      end

      cost = RideService.calculate_ride_cost(ride).round
      amount_in_cents = cost * 100

      customer_email = ride.rider.email
      payment_source_id = ride.rider.payment_source_id
      reference = "Ride#{ride_id}-#{DateTime.now.to_s}"

      transaction_result = PaymentService.create_transaction(
        amount_in_cents, # Monto en centavos
        'COP', # Moneda
        customer_email,
        payment_source_id,
        reference
      )

      if transaction_result['error'] && !transaction_result['error'].empty?
        status 500
        return { error: 'Failed to create payment transaction', details: transaction_result['error'] }.to_json
      end

      ride.update(
        status: 'completed',
        cost: cost,
        completed_at: DateTime.now
      )

      status 200
      response = { message: 'Ride completed successfully', cost: cost }.to_json
    rescue JSON::ParserError
      status 400
      { error: 'Invalid JSON format' }.to_json
    rescue StandardError => e
      status 500
      { error: 'Internal server error', message: e.message }.to_json
    end
  end
end
