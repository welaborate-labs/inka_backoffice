require "net/http"
require "uri"

class Services::FocusNfeApi
  URL_API = ENV['FOCUSNFE_URL']
  TOKEN = ENV['FOCUSNFE_KEY']

  def initialize(bill)
    @bill = bill
  end

  def create
    url = URI(URL_API + "v2/nfse?ref=" + @bill.reference)
    puts "create_url: #{url}"

    https = Net::HTTP.new(url.hostname, url.port)
    https.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request["Authorization"] = "Basic " + Base64.encode64(TOKEN).strip
    request["Content-Type"] = "application/json"

    customer_payload = {
      "razao_social": I18n.transliterate(@bill.customer&.name.to_s),
      "email": @bill.customer&.email.present? ? @bill.customer&.email : '-',
      "endereco": {
        "logradouro": I18n.transliterate(@bill.customer&.street_address.present? ? @bill.customer&.street_address : '-'),
        "numero": @bill.customer&.number&.to_s.present? ? @bill.customer&.number&.to_s : '-',
        "complemento": I18n.transliterate(@bill.customer&.complement.present? ? @bill.customer&.complement : '-'),
        "bairro": I18n.transliterate(@bill.customer&.district.present? ? @bill.customer&.district : '-'),
        "codigo_municipio": "3530607",
        "uf": @bill.customer&.state.present? ? @bill.customer&.state : '-',
        "cep": @bill.customer&.zip_code.to_s.present? ? @bill.customer&.zip_code.to_s : '-'
      }
    }

    if @bill.customer&.document_numbers.size > 11
      customer_payload.merge!({ "cnpj": @bill.customer&.document_numbers })
    else
      customer_payload.merge!({ "cpf": @bill.customer&.document_numbers })
    end

    payload = {
      "data_emissao": @bill.created_at.in_time_zone('America/Sao_Paulo').to_s,
      "optante_simples_nacional": true,
      "regime_especial_tributacao": "6",
      "natureza_operacao": "1",
      "prestador": {
        "cnpj": "43200148000182",
        "inscricao_municipal": "107273",
        "codigo_municipio": "3530607"
      },
      "tomador": customer_payload,
      "servico": {
        "aliquota": 2,
        "iss_retido": "false",
        "codigo_cnae": "8690901",
        "codigo_tributario_municipio": "0602",
        "item_lista_servico": "0602",
        "codigo_municipio": "3530607",
        "discriminacao": I18n.transliterate(discriminacao),
        "valor_servicos": sprintf('%.2f', @bill.billed_amount)
      }
    }

    request.body = JSON.dump(payload)

    response = https.request(request)
    JSON.parse(response.body)
  end

  def base_discriminacao
    @bill.billables[0].is_a?(Booking) ? 'Serviços ' : 'Vale Presente '
  end

  def services_discriminacao
    @bill.billables.map { |billable| billable.title }.join(",")
  end

  def discriminacao
    if @bill.description.present?
      return @bill.description
    end

    base_discriminacao + services_discriminacao
  end

  def get
    url = URI(URL_API + "v2/nfse/" + @bill.reference)
    puts "get_url: #{url}"

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Get.new(url)

    request["Authorization"] = "Basic " + Base64.encode64(TOKEN).strip

    response = https.request(request)
    JSON.parse(response.body)
  end

  def cancel(justification)
    url = URI(URL_API + "v2/nfse/" + @bill.reference)
    puts "cancel_url: #{url}"

    canceled_justification = { justificativa: justification.to_s }

    https = Net::HTTP.new(url.hostname, url.port)
    https.use_ssl = true

    request = Net::HTTP::Delete.new(url)

    request["Authorization"] = "Basic " + Base64.encode64(TOKEN).strip

    request.body = canceled_justification.to_json

    response = https.request(request)
    JSON.parse(response.body)
  end
end
