require 'httparty'
require 'base64'
require 'json'
require 'base64'

class PacClient
  BASE_URL = "#{ENV['FACTURAMA_API_URL']}/3/cfdis"
  USER = ENV['FACTURAMA_USER']
  PASS = ENV['FACTURAMA_PASSWORD']

  def initialize(payload)
    @payload = payload
  end

  def create_payment_complement
    response = send_request
    parsed = parse_response(response)
    validate_response(parsed)
  end


  def self.download_pdf(id_factura)
    uri = URI("#{ENV['BASE_URL']}/pdf/issuedLite/#{id_factura}")
    req = Net::HTTP::Get.new(uri)
    req.basic_auth(USER, PASS)

    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(req) }
    raise "Error PDF: #{res.body}" unless res.code.to_i == 200

    data = JSON.parse(res.body)
    Base64.decode64(data['Content'])
  end

  private

  attr_reader :payload

  def send_request
    uri = URI(BASE_URL)
    request = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
    request.basic_auth(USER, PASS)
    request.body = payload.to_json

    Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end
  rescue => e
    raise "Error de conexión con PAC: #{e.message}"
  end

  def parse_response(response)
    JSON.parse(response.body)
  rescue JSON::ParserError
    { "error" => "Respuesta inválida del PAC: #{response.body}" }
  end

  def validate_response(parsed)
    if parsed["Id"].present?
      parsed
    else
      raise "Error al timbrar complemento de pago: #{parsed.inspect}"
    end
  end
end
