require 'sinatra/base'
require 'json'
require_relative '../validations/payment_method_validation'
require_relative '../validations/ride_request_validation'
require_relative '../services/payment_service'
require_relative '../services/rider_service'

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

    validation = Validations::RideRequestSchema.new.call(request_body)
    if validation.failure?
      status 400
      return { error: validation.errors.to_h }.to_json
    end

    begin
      latitude = request_body['latitude'].to_f
      longitude = request_body['longitude'].to_f
      destination = request_body['destination']
      rider_id = params[:id]
      rider = Rider.find(id: rider_id)

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

  post '/riders/:id/add_payment_method' do
    content_type :json

    request_payload = JSON.parse(request.body.read)
    payment_token = request_payload['payment_token']
    customer_email = request_payload['customer_email']

    begin
      rider = RiderService.add_payment_method(params[:id], payment_token, customer_email)
      status 200
      { message: 'Payment method added successfully' }.to_json
    rescue => e
      status 500
      { error: 'Internal server error', details: e.message }.to_json
    end
  end
end
