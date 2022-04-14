class TimeslotService
  def self.generate_timeslots(starts_at:, ends_at:)
    GenerateTimeslotsCommand.new(starts_at: starts_at, ends_at: ends_at).run
  end
end
