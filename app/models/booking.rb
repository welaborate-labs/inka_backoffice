class Booking < ApplicationRecord
  belongs_to :customer
  belongs_to :service
  belongs_to :professional

  before_validation :set_booking_datetime, :set_start_and_ends_at, :get_available_booking
  before_save :update_canceled_at, if: -> { status_changed? }
  before_update :create_stock_decrement, if: -> { status == "completed" }

  validates :status, :booking_datetime, presence: true

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

  def set_booking_datetime
    self.booking_datetime =
      DateTime.new(
        booking_datetime[1],
        booking_datetime[2],
        booking_datetime[3],
        booking_datetime[4],
        booking_datetime[5]
      )
  end

  def set_start_and_ends_at
    self.starts_at = booking_datetime
    self.ends_at = booking_datetime + sum_duration.minutes
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
      StockDecrement.create product_id: product_usage.product_id,
                            quantity: product_usage.quantity,
                            integralized_at: DateTime.now
    end
  end

  def self.status_attributes_for_select
    statuses.map do |status, _|
      [I18n.t("activerecord.attributes.#{model_name.i18n_key}.statuses.#{status}"), status]
    end
  end

  def get_available_booking
    return if !booking_datetime || !service

    occupation =
      professional.occupations.where(
        "professional_id = ? and ends_at >= ? and ends_at <= ?",
        professional_id,
        booking_datetime,
        booking_datetime + sum_duration.minutes
      )

    schedules =
      professional
        .schedules
        .where(
          "weekday = ? and starts_at >= ? and interval_starts_at <= ?",
          booking_datetime.wday,
          booking_datetime.hour,
          round_datetime_sum_hour
        )
        .or(
          professional.schedules.where(
            "weekday = ? and interval_ends_at >= ? and ends_at <= ?",
            booking_datetime.wday,
            booking_datetime.hour,
            round_datetime_sum_hour
          )
        )

    return errors.add(:booking_datetime, "não disponível.") if occupation.any? || !schedules.any?

    professional.occupations.create!(
      professional_id: professional_id,
      service_id: service_id,
      starts_at: starts_at,
      ends_at: ends_at
    )
  end

  def round_datetime_sum_hour
    rest = (booking_datetime.hour + sum_duration.minutes).to_i % 60

    return (60 - rest) + rest if rest % 60 > 0
  end
end
