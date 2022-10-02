module CalendarHelper
  def booking_calendar_status_bg(booking)
    case booking.status.to_sym
    when :customer_canceled, :professional_canceled
      'has-background-danger-light'
    when :in_progress
      'has-background-primary-light'
    when :completed
      'has-background-success-light'
    else
      'has-background-info-light'
    end
  end
end
