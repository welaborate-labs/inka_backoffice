require "services/focus_nfe_api"

class Bill < ApplicationRecord
  has_many :bookings

  validate :booking_validation
  validates :justification, length: { within: 2..150 }, on: :destroy

  after_create :set_reference
  after_create :create_nfse

  before_save :calculate_amount
  before_save :calculate_discounted_value, if: -> { discount.present? }


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
    CreateNfseJob.perform_now(self)
  end

  def status
    bookings.any? ? bookings.first.status : "estado da nota não encontrado"
  end

  private

  def booking_validation
    if bookings.empty?
      errors.add(:bookings, 'não pode ficar em branco.')
    end
  end

  def set_reference
    self.update(reference: self.to_sgid(expires_in: nil).to_s)
  end
end
