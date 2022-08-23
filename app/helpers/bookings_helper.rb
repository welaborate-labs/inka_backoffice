module BookingsHelper
  def status_attributes_for_select
    Booking.statuses.map do |status, _|
      [I18n.t("activerecord.attributes.booking.statuses.#{status}"), status]
    end
  end

  def bookings_total_price(bookings)
    bookings.reduce(0) do |sum, booking|
      sum += booking.sum_price
    end
  end

  def bookings_total_duration(bokings)
    bookings.reduce(0) do |total, booking|
      total += booking.sum_duration
    end
  end
end
