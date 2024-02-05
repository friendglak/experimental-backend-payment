require 'spec_helper'
require 'rack/test'
require_relative '../../app'
require_relative '../../app/controllers/riders_controller'
require_relative '../../app/models/ride'
require_relative '../../app/models/driver'
require_relative '../../app/models/rider'
require_relative '../../app/services/payment_service'

RSpec.describe RidersController, type: :controller do
  include Rack::Test::Methods

  def app
    RideHailingApp
  end

  describe 'POST /riders/:id/payment_methods' do
    let(:rider) { create(:rider) }

    before do
      mock_response = { 'data' => { 'id' => SecureRandom.hex(10) } } # Genera un ID aleatorio para el mock
      allow(PaymentService).to receive(:create_payment_source).and_return(mock_response)
    end

    it 'creates a payment method successfully' do
      payload = { payment_token: SecureRandom.hex(8) } # Simula un token generado aleatoriamente
      post "/riders/#{rider.id}/payment_methods", payload.to_json, { 'CONTENT_TYPE' => 'application/json' }

      expect(last_response.status).to eq(201)
      response_data = JSON.parse(last_response.body)
      expect(response_data['message']).to eq('Payment source created successfully')
      expect(response_data).to have_key('payment_source_id')
    end
  end

  describe 'POST /riders/:id/ride_requests' do
    let(:rider) { create(:rider, name: 'Rider Request', email: 'riderrequest@example.com') }
    let(:driver) do
      create(:driver, name: 'Driver Request', email: 'driverrequest@example.com', latitude: 1.0, longitude: 1.0,
                      available: true)
    end

    let(:ride_details) { { current_location: '123 Main St', destination: '456 Elm St' } }

    before do
      allow(RideService).to receive(:assign_driver).and_return(driver)
      allow(Ride).to receive(:create).and_return(Ride.new(rider_id: rider.id, driver_id: driver.id,
                                                          start_location: ride_details[:current_location], status: 'pending'))
    end

    it 'requests a ride' do
      post "/riders/#{rider.id}/ride_requests", ride_details.to_json, { 'CONTENT_TYPE' => 'application/json' }
      expect(last_response.status).to eq(201)
      response_data = JSON.parse(last_response.body)
      expect(response_data['message']).to eq('Ride requested successfully')
      expect(response_data).to have_key('ride_id')
      expect(response_data).to have_key('driver_id')
    end
  end
end
