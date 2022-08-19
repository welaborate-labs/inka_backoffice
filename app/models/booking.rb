class Booking < ApplicationRecord
  belongs_to :customer
  belongs_to :service
  belongs_to :professional
  belongs_to :bill, optional: :true

  before_validation :set_ends_at
  before_save :update_canceled_at, if: -> { status_changed? }
  before_update :create_stock_decrement, if: -> { status == "completed" }

  validates :status, presence: true
  validates :starts_at, presence: true
  validates :ends_at, presence: true

  validate :professional_is_available, if: -> { starts_at_changed? && status != "completed" }
  validate :schedule_is_available, if: -> { status != "completed" }

  scope :active, -> { where.not(status: [:customer_canceled, :professional_canceled, :absent]) }

  enum status: %i[
    requested
    accepted
    confirmed
    in_progress
    customer_canceled
    professional_canceled
    absent
    completed
  ]

  def customer_name
    Customer.find(customer_id).name
  end

  def professional_name
    Professional.find(professional_id).name
  end

  def calendar_names
    "#{customer_name} - #{professional_name}"
  end

  def sum_duration
    service.duration + service.optional_services&.sum(:duration)
  end

  def sum_price
    service.price + service.optional_services&.sum(:price)
  end

  def is_inactive?
    %w(customer_canceled professional_canceled absent).include? status
  end

  private

  def set_ends_at
    self.ends_at = self.starts_at + sum_duration&.minutes if self.starts_at && sum_duration
  end

  def update_canceled_at
    if status == "customer_canceled" || status == "professional_canceled"
      self.canceled_at = DateTime.now
    else
      self.canceled_at = nil
    end
  end

  def create_stock_decrement
    service.product_usages.each { |product_usage|
      StockDecrement.create(
        product_id: product_usage.product_id, quantity: product_usage.quantity, integralized_at: DateTime.now
      )
    }
  end

  def professional_is_available
    if professional&.bookings&.active&.where("starts_at < ? AND ends_at > ?", ends_at, starts_at).present?
      errors.add(:booking, "não disponível")
    end
  end

  def schedule_is_available
    return if !professional

    schedule = professional&.schedules&.where("weekday = ? AND starts_at <= ? AND ends_at >= ?", ends_at.wday, starts_at.hour, ends_at.hour).first

    if !schedule || (starts_at.hour.between?(schedule.interval_starts_at, schedule.interval_ends_at) ||
        ends_at.hour.between?(schedule.interval_starts_at, schedule.interval_ends_at))
      errors.add(:professional, "não possui agenda para esse horário")
    end
  end
end
