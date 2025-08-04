require 'httparty'
require 'base64'

class PacClient
  include HTTParty

  BASE_URL = "#{ENV['FACTURAMA_API_URL']}/3/cfdis"
  USER = ENV['FACTURAMA_USER']
  PASS = ENV['FACTURAMA_PASSWORD']

  def self.create_payment_complement(data)
    uri = URI(BASE_URL)
    req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
    req.basic_auth(USER, PASS)
    req.body = data.to_json

    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(req) }
    JSON.parse(res.body)
  rescue => e
    { "error" => e.message }
  end
end
