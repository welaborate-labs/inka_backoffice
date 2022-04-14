class Timeslot < ApplicationRecord
  belongs_to :schedule

  enum status: %i[free booked absent]

  validates :starts_at, :ends_at, :status, presence: :true
end
