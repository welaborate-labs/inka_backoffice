require "services/focus_nfe_api"

class Bill < ApplicationRecord
  has_many :bookings
  has_many :professionals, through: :bookings

  validates :bookings, presence: true, on: :create
  validates :justification, length: { within: 2..150 }, on: :destroy
  validate :duplicated, on: :create

  before_create :set_billing_status
  after_create :set_bookings_billing_status, :set_reference, :create_nfse

  before_save :calculate_amount
  before_save :calculate_discounted_value, if: -> { discount.present? }
  before_save :calculate_billed_amount

  scope :billing_or_billed, -> { where(status: [:billing, :billed]) }

  enum status: %i[
         billing
         billed
         billing_failed
         billing_canceled
       ]

  def calculate_amount
    self.amount = bookings.reduce(0) { |sum, booking| sum += booking.service.price }.to_f
  end

  def calculate_discounted_value
    self.discounted_value = (self.amount * (self.discount.to_f / 100)).ceil
  end

  def calculate_billed_amount
    self.billed_amount ||= amount.to_f - discounted_value.to_f
  end

  def create_nfse
    CreateNfseJob.perform_now(self)
  end

  def set_billing_status
    self.status = :billing
  end

  def set_bookings_billing_status
    bookings.update_all(status: :billing)
  end

  def set_reference
    self.update(reference: self.to_sgid.to_s)
  end

  private

  def duplicated
    return unless Bill.billing_or_billed.includes(:bookings).pluck("bookings.id").reject(&:nil?).any? do |booking_id|
      booking_ids.include?(booking_id)
    end

    errors.add(:bookings, "Serviços já fechados. Cancele a nota fiscal gerada antes de tentar novamente.")
  end
end
