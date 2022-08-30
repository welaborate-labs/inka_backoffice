require "net/http"
require "uri"

class FocusNfeApi
  URL_API = ENV['FOCUSNFE_URL']
  TOKEN = Rails.application.credentials.api_keys&.dig(:focus_nfe)

  def initialize(booking)
    @booking = booking
  end

  def create
    url = URI(URL_API + "v2/nfse?ref=" + @booking.to_sgid(expires_in: nil).to_s)

    https = Net::HTTP.new(url.hostname, url.port)
    https.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request["Authorization"] = "Basic " + Base64.encode64(TOKEN).strip
    request["Content-Type"] = "application/json"

    request.body = JSON.dump({
      "data_emissao": @booking.created_at.to_s,
      "prestador": {
        "cnpj": "43200148000182",
        "inscricao_municipal": "107273",
        "codigo_municipio": "3530607"
      },
      "tomador": {
        "razao_social": @booking.customer_name,
        "cpf": @booking.customer.document.to_s,
        "email": @booking.customer.email,
        "endereco": {
          "logradouro": @booking.customer.street_address,
          "numero": @booking.customer.number.to_s,
          "complemento": @booking.customer.complement,
          "bairro": @booking.customer.district,
          "codigo_municipio": "3530607",
          "uf": @booking.customer.state,
          "cep": @booking.customer.zip_code.to_s
        }
      },
      "servico": {
        "aliquota": 2,
        "discriminacao": @booking.service.title,
        "iss_retido": "false",
        "item_lista_servico": "0601",
        "codigo_tributario_municipio": "620910000",
        "valor_servicos": @booking.service.price,
        "codigo_municipio": "3530607"
      }
    })

    response = https.request(request)
    response.body
  end

  def show
    url = URI(URL_API + "v2/nfse/" + @booking.to_sgid(expires_in: nil).to_s)

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Get.new(url)

    request["Authorization"] = "Basic " + Base64.encode64(TOKEN).strip

    response = https.request(request)
    response.body
  end

  def cancel justification
    url = URI(URL_API + "v2/nfse/" + @booking.to_sgid(expires_in: nil).to_s)

    canceled_justification = {
      justificativa: justification.to_s
    }

    https = Net::HTTP.new(url.hostname, url.port)
    https.use_ssl = true

    request = Net::HTTP::Delete.new(url)

    request["Authorization"] = "Basic " + Base64.encode64(TOKEN).strip

    request.body = canceled_justification.to_json

    response = https.request(request)
    response.body
  end
end
