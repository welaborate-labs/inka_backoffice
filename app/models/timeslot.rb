class Timeslot < ApplicationRecord
  belongs_to :schedule

  # Validations
  # presence
  validates :starts_at, :ends_at, presence: { message: "can't be blank or is invalid" }
end
