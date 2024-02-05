require 'sinatra/base'
require 'json'
require_relative '../validations/payment_method_validation'
require_relative '../validations/ride_request_validation'
require_relative '../services/payment_service'

# Controller to handle rider actions
class RidersController < Sinatra::Base
  post '/riders/:id/payment_methods' do
    content_type :json

    schema = Validations::PaymentMethodSchema.new
    result = schema.call(params)

    payment_token = params['token']
    customer_email = params['customer_email']

    result = PaymentService.create_payment_source(params[:id], payment_token, customer_email)

    if result[:error]
      status 500
      { error: result[:error] }.to_json
    else
      status 201
      response = { message: 'Payment source created successfully', payment_source_id: result['data']['id'] }.to_json
      puts 'Payment source created successfully ✅'
      response
    end
  end

  # POST /riders/:id/ride_requests

  post '/riders/:id/ride_requests' do
    content_type :json
    request_body = JSON.parse(request.body.read)
    puts request_body

    begin
      latitude = request_body['latitude'].to_f
      longitude = request_body['longitude'].to_f
      destination = request_body['destination']
      rider_id = params[:id]
      rider = Rider.find(id: rider_id)

      # Verifica si el rider existe
      if rider.nil?
        status 404
        return { error: "Rider with id #{rider_id} not found" }.to_json
      end

      driver = RideService.assign_driver(latitude, longitude, destination)
      ride = Ride.create(rider_id: rider.id, driver_id: driver.id, start_location: "#{longitude}, #{latitude}",
                         end_location: destination, status: 'pending')
      status 201
      { message: 'Ride requested successfully', ride_id: ride.id, rider_id: rider.id, driver_id: driver.id,
        destination: destination }.to_json
    rescue Sequel::NoMatchingRow
      status 404
      { error: 'Rider or Driver not found' }.to_json
    rescue StandardError => e
      status 500
      puts "error: #{e.message.to_json}"
    end
  end
end
