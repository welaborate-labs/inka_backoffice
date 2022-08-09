require "net/http"
require "uri"

class FocusNfeApi
  def initialize(booking)
    @booking = booking
    @token = ENV['FOCUSNFE_KEY']
    @url_api = ENV['FOCUSNFE_URL']
  end

  def create
    url = URI(@url_api + "v2/nfse?ref=" + @booking.id.to_s)

    https = Net::HTTP.new(url.hostname, url.port)
    https.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request["Authorization"] = "Basic " + Base64.encode64(@token).strip
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
          "codigo_municipio": "3530607", # valor fixo
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
        "codigo_municipio": "3530607" # valor fixo
      }
    })

    response = https.request(request)
    response.body
  end

  def show
    url = URI(@url_api + "v2/nfse/" + @booking.id.to_s)

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Get.new(url)

    request["Authorization"] = "Basic " + Base64.encode64(@token).strip

    response = https.request(request)
    response.body
  end

  def cancel justification
    url = URI(@url_api + "v2/nfse/" + @booking.id.to_s)

    canceled_justification = {
      justificativa: justification.to_s
    }

    https = Net::HTTP.new(url.hostname, url.port)
    https.use_ssl = true

    request = Net::HTTP::Delete.new(url)

    request["Authorization"] = "Basic " + Base64.encode64(@token).strip

    request.body = canceled_justification.to_json

    response = https.request(request)
    response.body
  end
end
