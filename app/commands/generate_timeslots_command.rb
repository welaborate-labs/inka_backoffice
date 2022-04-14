class GenerateTimeslotsCommand
  attr_reader :starts_at, :ends_at
  attr_accessor :timeslots

  def initialize(starts_at:, ends_at:)
    @starts_at = starts_at
    @ends_at = ends_at
    @timeslots = []
  end

  def run
    (starts_at..ends_at).each do |date|
      schedules = Schedule.where(weekday: date.wday).order('starts_at ASC')

      schedules.each do |schedule|
        if schedule
             .timeslots
             .where('starts_at >= ? and ends_at <= ?', date, date.end_of_day)
             .exists?
          next
        end

        (schedule.starts_at..schedule.interval_starts_at).each do |hour|
          if hour != schedule.interval_starts_at
            self.timeslots.push(
              schedule.timeslots.create(
                starts_at: DateTime.new(date.year, date.month, date.day, hour),
                ends_at: DateTime.new(date.year, date.month, date.day, hour + 1)
              )
            )
          end
        end

        (schedule.interval_ends_at..schedule.ends_at).each do |hour|
          if hour != schedule.ends_at
            self.timeslots.push(
              schedule.timeslots.create(
                starts_at: DateTime.new(date.year, date.month, date.day, hour),
                ends_at: DateTime.new(date.year, date.month, date.day, hour + 1)
              )
            )
          end
        end
      end
    end
    @success = true
  rescue StandardError => error
    @success = false

    errors.push(error)
  end

  def rollback
    Timeslot.where(id: timeslots.map(&:id)).destroy_all
  end

  def success?
    @success
  end

  def errors
    []
  end
end
