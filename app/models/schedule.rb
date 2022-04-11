class Schedule < ApplicationRecord
  HOURS = (0..23).to_a

  belongs_to :professional
  has_many :timeslots, dependent: :destroy
  enum weekday: %i[sunday monday tuesday wednesday thursday friday saturday]

  validates :weekday, :starts_at, :ends_at, presence: true
  validates :interval_starts_at,
            :interval_ends_at,
            presence: true

  validates :starts_at, inclusion: { in: HOURS }
  validates :ends_at, inclusion: { in: HOURS }
  validates :interval_starts_at, inclusion: { in: HOURS }
  validates :interval_ends_at, inclusion: { in: HOURS }
end
