require 'services/focus_nfe_api'

class CreateNfseJob < ApplicationJob
  queue_as :default

  after_perform do |job|
    GetNfseJob.set(wait: 10.seconds).perform_later(job.arguments.first)
  end

  def perform(bill)
    bill.bookings.update_all(status: :billing)
    FocusNfeApi.new(bill).create
  end
end
