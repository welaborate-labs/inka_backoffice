require 'services/focus_nfe_api'

class GetNfseJob < ApplicationJob
  queue_as :default

  after_perform do |job|
    case @response["status"]
    when "nao_encontrado"
    when "nfe_cancelada"
    when "nfe_nao_autorizada"
    when "requisicao_invalida"
      # notify the wrong fields
    when "empresa_nao_habilitada"
      # notify via email the company
    when "certificado_vencido"
      # notify via email the company
    when "nfe_autorizada"
      # save the xml or url and send email
    when "em_processamento"
      GetNfseJob.set(wait: 5.minutes).perform_later(job.arguments.first)
    else
      @response
    end
  end

  def perform(bill)
    @response = FocusNfeApi.new(bill).get
  end
end
