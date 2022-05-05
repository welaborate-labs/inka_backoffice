class Timeslot < ApplicationRecord
  belongs_to :schedule
  has_many :service_bookings, dependent: :destroy

  enum status: %i[free booked absent]

  validates :starts_at, :ends_at, :status, presence: :true
end
