class ReportService
  attr_reader :date_start, :date_end

  def initialize(date_start:, date_end:)
    @date_start = date_start
    @date_end = date_end
  end

  def revenue
    @revenue ||= Bill
      .where(created_at: [date_start..date_end])
      .where(status: :billed)
      .to_a
      .sum(&:billed_amount)
  end

  def completed_bookings
    @completed_bookings ||= bookings.completed.count
  end

  def cancelled_bookings
    @cancelled_bookings ||= bookings
      .where(status: [:professional_canceled, :customer_canceled])
      .count
  end

  def absent_bookings
    @absent_bookings ||= bookings
      .absent
      .count
  end

  def completed_bookings_per_weekday
    @completed_bookings_per_weekday =|| bookings
      .completed
      .group_by |booking| do
        booking.starts_at.wday
      end
      .map do |weekday, bookings|
        { [weekday] => bookings.size }
      end
  end

  def completed_services
    @completed_services ||= services
      .completed
      .group('services.id')
      .count
      .map do |service_id, service_count|
        { [Service.find(service_id).title] => service_count }
      end
  end

  def completed_services_per_weekday
    @completed_services_per_weekday ||= bookings
    .completed
    .reduce({}) do |hash, booking|
      hash[Service.find(service_id).title] ||= 0
      hash[Service.find(service_id).title][booking.starts_at.wday] += 1
    end
  end

  def new_customers
    @new_customers ||= customers.where(created_at: [date_start..date_end]).count
  end

  def recurrent_customers
    @old_customers ||= customers.where('customers.created_at < ?', date_start).count
  end

  def total_customers
    @total_customers ||= customers.where("created_at < ?", date_end).count
  end

  private

  def customers
    Customer
      .joins(:bookings)
      .where('bookings.created_at < ?', [date_start..date_end])
      .where(bookings: { status: :completed })
  end

  def bookings
    Booking.where(starts_at: [date_start..date_end])
  end

  def services
    Service
      .joins(:bookings)
      .where(bookings: { starts_at: [date_start..date_end] })
  end
end
