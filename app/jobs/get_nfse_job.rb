require 'services/focus_nfe_api'

class GetNfseJob < ApplicationJob
  queue_as :default

  after_perform do |job|
    case @response["status"]
    when "em_processamento"
      GetNfseJob.set(wait: 5.minutes).perform_later(job.arguments.first)
    end
  end

  def perform(bill)
    @response = FocusNfeApi.new(bill).get
  end
end
