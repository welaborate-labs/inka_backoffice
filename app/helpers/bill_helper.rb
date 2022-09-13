require "services/focus_nfe_api"

module BillHelper
  URL_FOCUS_API = ENV['FOCUSNFE_URL']

  def self.create_nfse_request(bill)
    CreateNfseJob.perform_now(bill)
  end

  def self.get_nfse_request(bill)
    FocusNfeApi.new(bill).get
  end

  def self.verify_status(bill, response)
    case response["status"]
    when "autorizado" || "cancelado"
      authorized_or_canceled(bill, response["url"], response["caminho_xml_nota_fiscal"], response["status"])
    when "erro_autorizacao"
      authorization_error(bill, response)
    when "em_processamento" || "processando_autorizacao"
      processing(bill)
    else
      return
    end
  end

  def self.authorized_or_canceled(bill, pdf, xml, status)
    status == "autorizado" ? bill.bookings.update_all(status: :billed) : bill.bookings.update_all(status: :billing_canceled)

    bill.update(pdf_url: pdf, xml_url: "#{URL_FOCUS_API}#{xml}")
  end

  def self.authorization_error(bill, response)
    bill.bookings.update_all(status: :billing_failed)
    bill.update(error_message: response["erros"][0]["mensagem"].split(/\r\n/).reject(&:empty?))
  end

  def self.processing(bill)
    bill.bookings.update_all(status: :billing)
    GetNfseJob.perform_later(bill)
  end
end
