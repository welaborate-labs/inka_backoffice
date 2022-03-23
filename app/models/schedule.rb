class Schedule < ApplicationRecord
  belongs_to :professional
  enum weekday: %i[monday tuesday wednesday thursday friday]

  # Validations
  # presence
  validates :weekday, :starts_at, :ends_at, presence: true
  validates :interval_starts_at,
            :interval_ends_at,
            presence: true,
            if: lambda { self.interval_starts_at.present? || self.interval_ends_at.present? }

  # length within min..max
  validates :starts_at, length: { maximum: 15 }, if: lambda { self.starts_at.present? }
  validates :ends_at, length: { maximum: 15 }, if: lambda { self.ends_at.present? }
  validates :interval_starts_at,
            length: {
              maximum: 15
            },
            if: lambda { self.interval_starts_at.present? }
  validates :interval_ends_at,
            length: {
              maximum: 15
            },
            if: lambda { self.interval_ends_at.present? }
end
