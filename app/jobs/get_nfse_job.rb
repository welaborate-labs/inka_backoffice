require 'services/focus_nfe_api'

class GetNfseJob < ApplicationJob
  queue_as :default

  URL_FOCUS_API = ENV['FOCUSNFE_URL']

  def perform(bill)
    response = FocusNfeApi.new(bill).get

    case response["status"]
    when "autorizado"
      bill.bookings.update_all(status: :billed)
      bill.update(pdf_url: response["url"], xml_url: "#{URL_FOCUS_API}#{response["caminho_xml_nota_fiscal"]}")
    when "cancelado"
      bill.bookings.update_all(status: :billing_canceled)
      bill.update(pdf_url: response["url"], xml_url: "#{URL_FOCUS_API}#{response["caminho_xml_nota_fiscal"]}")
    when "erro_autorizacao"
      bill.bookings.update_all(status: :billing_failed)
      bill.update(error_message: response["erros"][0]["mensagem"].split(/\r\n/).reject(&:empty?))
    when "em_processamento" || "processando_autorizacao"
      bill.bookings.update_all(status: :billing)
      GetNfseJob.set(wait: 5.minutes).perform_later(bill)
    end
  end
end
