require "services/focus_nfe_api"

class Bill < ApplicationRecord
  has_many :bookings

  validate :booking_validation
  validates :justification, length: { within: 2..150 }, on: :destroy

  before_save :calculate_amount
  before_save :calculate_discounted_value, if: -> { discount.present? }

  after_save :create_nfse
  after_save :complete_bookings

  def calculate_amount
    self.amount = bookings.reduce(0) { |sum, booking| sum += booking.service.price }.to_f
  end

  def calculate_discounted_value
    self.discounted_value = (self.amount * (self.discount.to_f / 100)).ceil
  end

  def billed_amount
    @billed_amount ||= amount.to_f - discounted_value.to_f
  end

  def create_nfse
    # CreateNfseJob.perform_later(self)
    return true if is_gift

    FocusNfeApi.new(self).create
  end

  def get_pdf
    FocusNfeApi.new(self).get_url("url")
  end

  def get_xml
    focus = FocusNfeApi.new(self)

    focus.get_xml_url(focus.get_url("caminho_xml_nota_fiscal"))
  end

  def get_error_message
    error = FocusNfeApi.new(self).error_message
    error.nil? ? ["erro não informado"] : error
  end

  def status
    bookings ? bookings.first.status : "estado da nota não encontrado"
  end

  def complete_bookings
    bookings.update_all(status: :completed)
  end

  def complete_bookings
    bookings.update_all(status: :completed)
  end

  private

  def booking_validation
    if bookings.empty?
      errors.add(:bookings, 'não pode ficar em branco.')
    end
  end
end
