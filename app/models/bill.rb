require "services/focus_nfe_api"

class Bill < ApplicationRecord
  has_many :bookings

  validates :bookings, presence: true, on: :create
  validates :justification, length: { within: 2..150 }, on: :destroy
  validate :duplicated, on: :create

  after_create :set_reference
  after_create :create_nfse

  before_save :calculate_amount
  before_save :calculate_discounted_value, if: -> { discount.present? }

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

  def billed_amount
    @billed_amount ||= amount.to_f - discounted_value.to_f
  end

  def create_nfse
    CreateNfseJob.perform_now(self)
  end

  private

  def set_reference
    self.update(reference: self.to_sgid(expires_in: nil).to_s)
  end

  def duplicated
    return unless Bill.billing_or_billed.includes(:bookings).collect(&:booking_ids).any? do |booking_id|
      if booking_ids == booking_id
        errors.add(:bookings, 'Serviços já fechados. Cancele a nota fiscal gerada antes de tentar novamente.')
      end
    end
  end
end
