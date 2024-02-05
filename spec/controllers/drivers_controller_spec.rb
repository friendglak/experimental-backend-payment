require 'spec_helper'
require 'rack/test'
require_relative '../../app'
require_relative '../../app/controllers/drivers_controller'
require_relative '../../app/models/ride'
require_relative '../../app/models/driver'
require_relative '../../app/models/rider'

RSpec.describe DriversController, type: :controller do
  include Rack::Test::Methods

  def app
    RideHailingApp
  end

  describe 'POST /drivers/:id/finish_ride' do
    let(:driver) { create(:driver) }
    let(:rider) { create(:rider) }
    let(:ride) { create(:ride, driver: driver, rider: rider, status: 'active') }

    it 'finishes a ride' do
      post "/drivers/#{driver.id}/finish_ride", { ride_id: ride.id }.to_json, { 'CONTENT_TYPE' => 'application/json' }
      expect(last_response.status).to eq(200)
      response_data = JSON.parse(last_response.body)
      expect(response_data['message']).to eq('Ride completed successfully')
      # Optionally, verify that the ride status is now 'completed'
      updated_ride = Ride[ride.id]
      expect(updated_ride.status).to eq('completed')
    end
  end
end
