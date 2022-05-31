class ServiceBooking < ApplicationRecord
  TIMESLOT_DURATION = 30.freeze

  belongs_to :customer
  belongs_to :service
  has_many :timeslots, dependent: :destroy

  before_validation :set_booking_datetime
  before_validation :get_available_timeslot
  before_save :update_canceled_at, if: -> { status_changed? }

  validates :status, :booking_datetime, presence: true
  validate :validate_timeslots_duration

  before_update :create_stock_decrement, if: -> { status == 'completed' }

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

  private

  def update_canceled_at
    if status == 'customer_canceled' || status == 'professional_canceled'
      self.canceled_at = DateTime.now
    else
      self.canceled_at = nil
    end
  end

  def get_available_timeslot
    return if !booking_datetime || !service
    return true if timeslots.present? && timeslots.first.starts_at == booking_datetime

    final_booking_datetime =
      booking_datetime.to_datetime + (service.duration * get_necessary_timeslots).minutes

    self.timeslots =
      service
        .professional
        .timeslots
        .where(
          'service_booking_id IS NULL and timeslots.starts_at >= ? and timeslots.ends_at <= ?',
          booking_datetime.to_datetime,
          final_booking_datetime + set_get_free_time.minutes
        )
        .order('starts_at ASC')
  end

  def validate_timeslots_duration
    return if !service || !booking_datetime

    if sum_duration >= TIMESLOT_DURATION
      return if timeslots.last&.ends_at.to_i - timeslots.first&.starts_at.to_i >= sum_duration * 60
    end

    errors.add(:timeslots, 'not available for service duration')
  end

  def get_necessary_timeslots
    necessary_timeslots = 1
    time_counter = TIMESLOT_DURATION

    while time_counter < sum_duration
      necessary_timeslots += 1
      time_counter += TIMESLOT_DURATION
    end

    necessary_timeslots
  end

  def set_get_free_time
    if sum_duration > TIMESLOT_DURATION
      self.free_time ||= (TIMESLOT_DURATION * get_necessary_timeslots) % sum_duration
    else
      self.free_time ||= sum_duration % TIMESLOT_DURATION
    end
  end

  def sum_duration
    service.duration + service.optional_services&.sum(:duration)
  end

  def set_booking_datetime
    return if booking_datetime.present?

    self.booking_datetime = timeslots.first&.starts_at
  end

  def create_stock_decrement
    service.product_usages.each do |product_usage|
      DescrementStock.create product_id: product_usage.product_id,
                             quantity: product_usage.quantity,
                             integralized_at: DateTime.now
    end
  end
end
