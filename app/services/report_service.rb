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
      .sum(:billed_amount)
  end

  def completed_bookings
    @completed_bookings ||= bookings.completed.count
  end

  def canceled_bookings
    @canceled_bookings ||= bookings
      .where(status: [:professional_canceled, :customer_canceled])
      .count
  end

  def absent_bookings
    @absent_bookings ||= bookings
      .absent
      .count
  end

  def completed_bookings_per_weekday
    @completed_bookings_per_weekday ||= bookings
      .completed
      .order(starts_at: :asc)
      .group_by { |booking| booking.starts_at.wday }
      .map do |weekday, bookings|
      { [weekday] => bookings.size }
    end
  end

  def completed_services
    @completed_services ||= services
      .group("services.id")
      .count
      .map do |service_id, service_count|
      { [Service.find(service_id).title] => service_count }
    end
  end

  def completed_services_per_weekday
    @completed_services_per_weekday ||= bookings
      .completed
      .reduce({}) do |hash, booking|
        hash[Service.find(booking.service_id).title] ||= {}
        hash[Service.find(booking.service_id).title][booking.starts_at.wday] ||= 0
        hash[Service.find(booking.service_id).title][booking.starts_at.wday] += 1
        hash
    end
  end

  def new_customers
    @new_customers ||= customers.where(customers: { created_at: [date_start..date_end] }).distinct.count
  end

  def recurrent_customers
    @recurrent_customers ||= customers.where("customers.created_at < ?", date_start).distinct.count
  end

  def total_customers
    @total_customers ||= customers.where("customers.created_at < ?", date_end).distinct.count
  end

  private

  def customers
    Customer
      .joins(:bookings)
      .where(bookings: { starts_at: [date_start..date_end], status: :completed })
  end

  def bookings
    Booking.where(starts_at: [date_start..date_end])
  end

  def services
    Service
      .joins(:bookings)
      .where(bookings: { starts_at: [date_start..date_end], status: :completed })
  end
end
