class CalendarController < ApplicationController
  before_action :set_start_date
  before_action :set_date_range
  before_action :set_time_range

  def index
    @bookings = Booking.all.order('starts_at ASC')
  end

  private

  def set_start_date
    if params["start_date(1i)"].present?
      params[:start_date] = "#{params['start_date(1i)']}-#{params['start_date(2i)']}-#{params['start_date(3i)']}"
    end

    @start_date = params.fetch(:start_date, Date.today).to_date
  end

  def set_date_range
    @date_range = (@start_date.beginning_of_week..@start_date.end_of_week).to_a
  end

  def set_time_range
    lower_time = Schedule.minimum(:starts_at)
    higher_time = Schedule.maximum(:ends_at)
    @time_range = (lower_time..higher_time).to_a
  end
end
