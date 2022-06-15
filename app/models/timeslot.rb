class Timeslot < ApplicationRecord
  belongs_to :schedule
  belongs_to :booking, optional: true

  enum status: %i[free booked absent]

  validates :starts_at, :ends_at, :status, presence: :true
end
