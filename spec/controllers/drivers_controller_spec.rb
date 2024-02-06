require 'spec_helper'
require 'rack/test'
require_relative '../../app'
require_relative '../../app/controllers/drivers_controller'
require_relative '../../app/models/ride'
require_relative '../../app/models/driver'
require_relative '../../app/models/rider'
require_relative '../../app/services/payment_service'

RSpec.describe DriversController, type: :controller do
  include Rack::Test::Methods

  def app
    RideHailingApp
  end

  describe 'POST /drivers/:id/finish_ride' do
    let(:driver) { create(:driver) }
    let(:rider) { create(:rider, payment_source_id: 'dummy_payment_source_id') } # Asegúrate de que el rider tenga un payment_source_id
    let(:ride) { create(:ride, driver: driver, rider: rider, status: 'active', cost: 100) } # Asegúrate de que el ride tenga un costo

    before do
      # Mockear PaymentService.create_transaction para que siempre devuelva un éxito
      allow(PaymentService).to receive(:create_transaction).and_return('success' => true)
    end

    it 'finishes a ride and creates a payment transaction' do
      post "/drivers/#{driver.id}/finish_ride", { ride_id: ride.id }.to_json, { 'CONTENT_TYPE' => 'application/json' }

      expect(last_response.status).to eq(200)
      response_data = JSON.parse(last_response.body)
      expect(response_data['message']).to eq('Ride completed successfully')

      # Verifica que PaymentService.create_transaction haya sido llamado con los argumentos esperados
      expect(PaymentService).to have_received(:create_transaction).with(
        an_instance_of(Integer), # amount_in_cents
        'COP', # currency
        rider.email, # customer_email
        rider.payment_source_id, # payment_source_id
        an_instance_of(String) # reference
      )

      # Opcionalmente, verifica que el estado del viaje ahora sea 'completed'
      updated_ride = Ride[ride.id]
      expect(updated_ride.status).to eq('completed')
    end
  end
end
