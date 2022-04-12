class Timeslot < ApplicationRecord
  belongs_to :schedule
  has_many :service_bookings, dependent: :destroy

  validates :starts_at, :ends_at, presence: { message: "can't be blank or is invalid" }
end
