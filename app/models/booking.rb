class Booking < ApplicationRecord
  belongs_to :customer
  belongs_to :service
  belongs_to :professional

  before_validation :set_ends_at
  before_save :update_canceled_at, if: -> { status_changed? }
  before_update :create_stock_decrement, if: -> { status == "completed" }

  validates :status, presence: true
  validates :starts_at, presence: true
  validates :ends_at, presence: true

  validate :professional_is_available

  scope :active, -> { where.not(status: [:customer_canceled, :professional_canceled, :absent]) }

  enum status: %i[
    requested
    accepted
    confirmed
    customer_canceled
    professional_canceled
    absent
    completed
  ]

  attr_accessor :booking_datetime

  def sum_duration
    service.duration + service.optional_services&.sum(:duration) if service
  end

  private

  def set_ends_at
    self.ends_at = starts_at + sum_duration&.minutes if starts_at
  end

  def update_canceled_at
    if status == "customer_canceled" || status == "professional_canceled"
      self.canceled_at = DateTime.now
    else
      self.canceled_at = nil
    end
  end

  def create_stock_decrement
    service.product_usages.each do |product_usage|
      StockDecrement.create(
        product_id: product_usage.product_id,
        quantity: product_usage.quantity,
        integralized_at: DateTime.now
      )
    end
  end

  def professional_is_available
    if professional&.bookings&.active&.where("starts_at <= ? AND ends_at >= ?", ends_at, starts_at).present?
      errors.add(:professional, "not available")
    end
  end
end
