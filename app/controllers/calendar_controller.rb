class CalendarController < ApplicationController
  before_action :set_calendar_date
  before_action :set_time_range, only: %i[index]
  before_action :set_professional_time_range, only: %i[professional_daily professional_weekly]
  before_action :set_date_range, only: %i[professional_weekly]

  def index
    @bookings = Booking.active
    @professionals = Professional.all.order('name ASC')
  end

  def professional_daily; end

  def professional_weekly; end

  private

  def set_time_range
    lower_time = Schedule.minimum(:starts_at)
    higher_time = Schedule.maximum(:ends_at)
    @time_range = (lower_time..higher_time).to_a
  end

  def set_professional_time_range
    lower_time = current_user.professional.schedules.minimum(:starts_at)
    higher_time = current_user.professional.schedules.maximum(:ends_at)
    @time_range = (lower_time..higher_time).to_a
  end

  def set_date_range
    @date_range = (@calendar_date..@calendar_date + 1.week).to_a
  end

  def set_calendar_date
    if params["calendar_date(1i)"].present?
      params[:calendar_date] = "#{params['calendar_date(1i)']}-#{params['calendar_date(2i)']}-#{params['calendar_date(3i)']}"
    end

    @calendar_date = params.fetch(:calendar_date, Date.today).to_date
  end
end
