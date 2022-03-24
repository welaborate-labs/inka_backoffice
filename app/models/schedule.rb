class Schedule < ApplicationRecord
  belongs_to :professional
  enum weekday: %i[monday tuesday wednesday thursday friday saturday sunday]

  # Validations
  # presence
  validates :weekday, :starts_at, :ends_at, presence: true
  validates :interval_starts_at,
            :interval_ends_at,
            presence: true,
            if: lambda { self.interval_starts_at.present? || self.interval_ends_at.present? }

  # format
  REGEX_FORMAT = /\A([0-1]?[0-9]|2[0-3]):[0-5][0-9]\z/
  validates :starts_at,
            format: {
              with: REGEX_FORMAT,
              message: 'is invalid. (e.g. 00:00 .. 23:00)'
            },
            if: lambda { self.starts_at.present? }
  validates :ends_at,
            format: {
              with: REGEX_FORMAT,
              message: 'is invalid. (e.g. 00:00 .. 23:00)'
            },
            if: lambda { self.ends_at.present? }
  validates :interval_starts_at,
            format: {
              with: REGEX_FORMAT,
              message: 'is invalid. (e.g. 00:00 .. 23:00)'
            },
            if: lambda { self.interval_starts_at.present? }
  validates :interval_ends_at,
            format: {
              with: REGEX_FORMAT,
              message: 'is invalid. (e.g. 00:00 .. 23:00)'
            },
            if: lambda { self.interval_ends_at.present? }
end
