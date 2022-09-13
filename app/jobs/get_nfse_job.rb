require 'services/focus_nfe_api'

class GetNfseJob < ApplicationJob
  queue_as :default

  after_perform do |job|
    BillHelper.verify_status(job.arguments.first, @response)
  end

  def perform(bill)
    @response = FocusNfeApi.new(bill).get
  end
end
