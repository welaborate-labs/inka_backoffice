require "services/focus_nfe_api"

class Bill < ApplicationRecord
  has_many :bookings
  has_many :gift_cards
  has_many :professionals, through: :bookings

  validates :justification, length: { within: 2..150 }, on: :destroy
  # validate :duplicated, on: :create

  before_create :set_billing_status
  after_create :set_bookings_billing_status, :set_reference
  after_create :create_nfse, unless: -> { is_gift }

  before_save :calculate_amount
  before_save :calculate_discounted_value, if: -> { discount.present? }
  before_save :calculate_billed_amount

  scope :billing_or_billed, -> { where(status: [:billing, :billed]) }

  enum status: %i[
    billing
    billed
    billing_failed
    billing_canceled
    wont_bill
  ]

  def billables
    @billable ||= booking_ids.present? ? bookings : gift_cards
  end

  def customer
    @customer ||= billables.first&.customer
  end

  def calculate_amount
    self.amount = billables.reduce(0) { |sum, billable| sum += billable.billing_price }.to_f
  end

  def calculate_discounted_value
    self.discounted_value = (self.amount * (self.discount.to_f / 100)).ceil
  end

  def calculate_billed_amount
    self.billed_amount ||= amount.to_f - discounted_value.to_f
  end

  def create_nfse
    CreateNfseJob.perform_now(self.id)
  end

  def set_billing_status
    self.status = if is_gift
                    :wont_bill
                  else
                    :billing
                  end
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
