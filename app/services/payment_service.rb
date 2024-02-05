require 'dotenv/load'
require 'net/http'
require 'uri'
require 'json'

# Service to create a payment source
class PaymentService
  BASE_URL = "#{ENV['SANDBOX_URL']}"

  def self.get_acceptance_token
    uri = URI("#{BASE_URL}/merchants/#{ENV['PUBLIC_KEY']}")
    request = Net::HTTP::Get.new(uri, 'Content-Type' => 'application/json')
    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    if response.is_a?(Net::HTTPSuccess)
      response_body = JSON.parse(response.body)
      response_body.dig('data', 'presigned_acceptance', 'acceptance_token')
    else
      nil
    end
  end

  def self.create_payment_source(_rider_id, _payment_token, _customer_email)
    acceptance_token = get_acceptance_token
    return { error: 'Failed to get acceptance token' } if acceptance_token.nil?

    uri = URI("#{BASE_URL}/payment_sources")
    request = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json',

                                       'Authorization' => "Bearer #{ENV['PRIVATE_KEY']}")

    request_body = {
      type: 'CARD',
      token: 'tok_test_92306_42ca087A2428217d9CD7f50d1a7a309e', # Use the token provided by /v1/tokens/cards
      customer_email: 'pepito_perez@example.com',
      acceptance_token: acceptance_token
    }.to_json

    request.body = request_body

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    response_body = begin
      JSON.parse(response.body)
    rescue StandardError
      nil
    end

    if response.is_a?(Net::HTTPSuccess)
      response_body
    else
      { error: "Failed to create payment source, Status: #{response.code}, Body: #{response.body}" }
    end
  rescue JSON::ParserError => e
    { error: "Failed to parse response: #{e.message}" }
  end
end
