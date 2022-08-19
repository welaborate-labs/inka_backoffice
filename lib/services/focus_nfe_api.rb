require "net/http"
require "uri"

class FocusNfeApi
  URL_API = ENV['FOCUSNFE_URL']
  TOKEN = ENV['FOCUSNFE_KEY']

  def initialize(bill)
    @bill = bill
  end

  def create
    url = URI(URL_API + "v2/nfse?ref=" + @bill.to_sgid(expires_in: nil).to_s)

    https = Net::HTTP.new(url.hostname, url.port)
    https.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request["Authorization"] = "Basic " + Base64.encode64(TOKEN).strip
    request["Content-Type"] = "application/json"

    request.body = JSON.dump({
      "data_emissao": @bill.created_at.to_s,
      "prestador": {
        "cnpj": "43200148000182",
        "inscricao_municipal": "107273",
        "codigo_municipio": "3530607"
      },
      "tomador": {
        "razao_social": @bill.bookings.first&.customer_name,
        "cpf": @bill.bookings.first&.customer.document.to_s,
        "email": @bill.bookings.first&.customer.email,
        "endereco": {
          "logradouro": @bill.bookings.first&.customer.street_address,
          "numero": @bill.bookings.first&.customer.number.to_s,
          "complemento": @bill.bookings.first&.customer.complement,
          "bairro": @bill.bookings.first&.customer.district,
          "codigo_municipio": "3530607",
          "uf": @bill.bookings.first&.customer.state,
          "cep": @bill.bookings.first&.customer.zip_code.to_s
        }
      },
      "servico": {
        "aliquota": 2,
        "iss_retido": "false",
        "codigo_tributario_municipio": "620910000",
        "item_lista_servico": "0601",
        "codigo_municipio": "3530607",
        "desconto_condicionado": @bill.discounted_value,
        "discriminacao": @bill.bookings.first&.service.title,
        "valor_servicos": @bill.calculate_amount.to_s
      }
    })

    response = https.request(request)
    JSON.parse(response.body)
  end

  def get
    url = URI(URL_API + "v2/nfse/" + @bill.to_sgid(expires_in: nil).to_s)

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Get.new(url)

    request["Authorization"] = "Basic " + Base64.encode64(TOKEN).strip

    response = https.request(request)
    JSON.parse(response.body)
  end

  def cancel(justification)
    url = URI(URL_API + "v2/nfse/" + @bill.to_sgid(expires_in: nil).to_s)

    canceled_justification = {
      justificativa: justification.to_s
    }

    https = Net::HTTP.new(url.hostname, url.port)
    https.use_ssl = true

    request = Net::HTTP::Delete.new(url)

    request["Authorization"] = "Basic " + Base64.encode64(TOKEN).strip

    request.body = canceled_justification.to_json

    response = https.request(request)
    JSON.parse(response.body)
  end
end
