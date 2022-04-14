class TimeslotService
  def self.generate_timeslots(starts_at:, ends_at:, status:)
    GenerateTimeslotsCommand.new(starts_at: starts_at, ends_at: ends_at, status: status).run
  end
end
