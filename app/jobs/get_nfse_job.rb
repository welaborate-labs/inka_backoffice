require 'services/focus_nfe_api'

class GetNfseJob < ApplicationJob
  queue_as :default

  after_perform do |job|
    case @response["status"]
    when "autorizado"
      job.arguments.first.bookings.update_all(status: :billed)
    when "erro_autorizacao"
      job.arguments.first.bookings.update_all(status: :billing_failed)
    when "cancelado"
      job.arguments.first.bookings.update_all(status: :billing_canceled)
    when "em_processamento" || "processando_autorizacao"
      GetNfseJob.set(wait: 5.minutes).perform_later(job.arguments.first)
    end
  end

  def perform(bill)
    @response = FocusNfeApi.new(bill).get
  end
end
