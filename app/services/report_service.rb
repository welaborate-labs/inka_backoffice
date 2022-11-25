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

  def billed_amounts
    @bill_amounts ||= Bill
      .where(created_at: [date_start..date_end])
      .where(status: :billed)
      .sum(:amount)
  end

  def billed_discounts
    @bill_discounts ||= Bill
      .where(created_at: [date_start..date_end])
      .where(status: :billed)
      .sum(:discounted_value)
  end

  def billed_discounts_ratio
    @billed_discounts_ratio ||= billed_amounts.zero? ? 0 : (billed_discounts.to_f / billed_amounts.to_f) * 100
  end

  def revenue_per_professional
    @revenue_per_professional ||= bookings
      .completed
      .joins(:professional, :service)
      .group('professionals.id')
      .distinct
      .sum('services.price')
      .map do |professional_id, service_amount|
        {
          professional: Professional.find(professional_id).name,
          revenue: service_amount
        }
      end
  end

  Bill.joins(bookings: :professionals)

  def total_bookings
    @total_bookings ||= bookings.count
  end

  def completed_bookings
    @completed_bookings ||= bookings.completed.count
  end

  def completed_bookings_ratio
    @completed_bookings_ratio ||= total_bookings.zero? ? 0 : (completed_bookings.to_f / total_bookings.to_f) * 100
  end

  def cancelled_bookings
    @canceled_bookings ||= bookings
      .where(status: [:professional_canceled, :customer_canceled])
      .count
  end

  def cancelled_bookings_ratio
    @cancelled_bookings_ratio ||= total_bookings.zero? ? 0 : (cancelled_bookings.to_f / total_bookings.to_f) * 100
  end

  def absent_bookings
    @absent_bookings ||= bookings
      .absent
      .count
  end

  def absent_bookings_ratio
    @absent_bookings_ratio ||= total_bookings.zero? ? 0 : (absent_bookings.to_f / total_bookings.to_f) * 100
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

  def completed_bookings_per_professional
    @completed_bookings_per_professional ||= bookings.completed
      .joins(:professional)
      .reduce({}) do |hash, booking|
        hash[booking.professional.name] ||= 0
        hash[booking.professional.name] += 1
        hash
      end
  end

  def completed_services
    @completed_services ||= services
      .group("services.id")
      .count
      .map do |service_id, service_count|
        {
          service: Service.find(service_id).title,
          count: service_count
        }
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
    @new_customers ||= customers.where(customers: { created_at: [date_start..date_end] }).count
  end

  def recurrent_customers
    @recurrent_customers ||= customers.where("customers.created_at < ?", date_start).count
  end

  def total_customers
    @total_customers ||= Customer.where("customers.created_at < ?", date_end).count
  end

  def serviced_customers
    @serviced_customers ||= customers.distinct.count
  end

  def count_diff_btw_worked_and_available
    @count_diff_btw_worked_and_available ||= bookings
    .reduce({}) do |hash, booking|
      hash[booking.professional.name] ||= {}
      hash[booking.professional.name]['total_schedule'] ||= Schedule.where(professional_id: booking.professional_id).reduce(0) { |c, s| c += (s.ends_at - s.starts_at)+(s.interval_ends_at - s.interval_starts_at) } || 0
      hash[booking.professional.name]['total_completed'] ||= Booking.where(professional_id: booking.professional_id).reduce(0) { |c, s| c += ((s.ends_at - s.starts_at) / 60).to_i } || 0
      hash[booking.professional.name]['total_rest'] ||= (Booking.where(professional_id: booking.professional_id).reduce(0) { |c, s| c += ((s.ends_at - s.starts_at) / 60).to_i }) - (Schedule.where(professional_id: booking.professional_id).reduce(0) { |c, s| c += (s.ends_at - s.starts_at)-(s.interval_ends_at - s.interval_starts_at) }) || 0
      hash
    end
  end

  def working_hours_per_professional
    @working_hours_per_professional ||= Schedule.joins(:professional).reduce({}) do |hash, schedule|
      (date_start..date_end).each do |day|
        if Schedule.weekdays[schedule.weekday] == day.wday
          hash[schedule.professional.name] ||= 0
          hash[schedule.professional.name] += schedule.ends_at - schedule.starts_at
          hash[schedule.professional.name] -= schedule.interval_ends_at - schedule.interval_starts_at
        end
      end

      hash
    end
  end

  def booked_hours_per_professional
    @booked_hours_per_professional ||= bookings
      .completed
      .joins(:professional)
      .reduce({}) do |hash, booking|
          hash[booking.professional.name] ||= 0
          hash[booking.professional.name] += (booking.ends_at - booking.starts_at) / 60 / 60
        hash
      end
  end

  def occupation_per_professional
    @occupation_per_professional ||= Professional.all.reduce({}) do |hash, professional|
      hash[professional.name] = booked_hours_per_professional[professional.name] / working_hours_per_professional[professional.name]
      hash
    end
  end

  def working_hours
    @working_hours ||= working_hours_per_professional.reduce(0) do |sum, (professional, working_hours)|
      sum += working_hours
    end
  end

  def booked_hours
    @booked_hours ||= booked_hours_per_professional.reduce(0) do |sum, (professional, booked_hours)|
      sum += booked_hours
    end
  end

  def occupation
    @occupation ||= booked_hours / working_hours
  end

  private

  def customers
    Customer
      .joins(:bookings)
      .where(bookings: { starts_at: [date_start..date_end], status: :completed })
      .distinct
  end

  def bookings
    @bookings ||= Booking.where(starts_at: [date_start..date_end])
  end

  def services
    Service
      .joins(:bookings)
      .where(bookings: { starts_at: [date_start..date_end], status: :completed })
  end
end


# O numero de servicos realizados por profissional
# Clientes que nao voltaram a mais de 30 dias
