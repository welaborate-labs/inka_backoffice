class CalendarController < ApplicationController
  def index
    @timeslots = Timeslot
      .joins(:schedule)
      .where(
        "timeslots.starts_at >= ? and timeslots.ends_at <= ?",
        Date.today.beginning_of_week,
        Date.today.end_of_week
      )
      .order("timeslots.starts_at ASC")
      .group_by do |timeslot|
        timeslot.schedule.weekday
      end
      .reduce({}) do |h, (day, timeslots)|
        h[day] = timeslots.group_by { |t| t.starts_at.strftime("%Hh%M") }
        h
      end

    @days = Date.today.beginning_of_week..Date.today.end_of_week
    @hours = @timeslots[@timeslots.keys[0]].keys
  end
end
