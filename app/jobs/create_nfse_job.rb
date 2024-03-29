require "services/focus_nfe_api"

class CreateNfseJob < ApplicationJob
  queue_as :default

  after_perform do |job|
    GetNfseJob.set(wait: 1.minute).perform_later(job.arguments.first)
  end

  def perform(bill_id)
    bill = Bill.find(bill_id)
    Services::FocusNfeApi.new(bill).create
  end
end
