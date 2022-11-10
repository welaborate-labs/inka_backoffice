require 'services/focus_nfe_api'

class GetNfseJob < ApplicationJob
  queue_as :default

  URL_FOCUS_API = ENV['FOCUSNFE_URL']

  def perform(bill)
    response = FocusNfeApi.new(bill).get

    case response["status"]
    when "autorizado"
      bill.update(status: :billed)
      bill.bookings.update_all(status: :completed)
      bill.update(pdf_url: response["url"], xml_url: "#{URL_FOCUS_API}#{response["caminho_xml_nota_fiscal"]}")
    when "cancelado"
      bill.update(status: :billing_canceled)
      bill.bookings.update_all(status: :in_progress)
      bill.update(pdf_url: response["url"], xml_url: "#{URL_FOCUS_API}#{response["caminho_xml_nota_fiscal"]}")
    when "erro_autorizacao"
      bill.update(status: :billing_failed)
      bill.bookings.update_all(status: :in_progress)
      bill.update(error_message: response["erros"][0]["mensagem"].split(/\r\n/).reject(&:empty?))
    when "em_processamento" || "processando_autorizacao"
      bill.update(status: :billing)
      bill.bookings.update_all(status: :billing)
      GetNfseJob.set(wait: 1.minute).perform_later(bill)
    end
  end
end
