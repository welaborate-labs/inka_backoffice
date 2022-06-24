class Schedule < ApplicationRecord
  HOURS = (0..23).to_a

  enum weekday: %i[sunday monday tuesday wednesday thursday friday saturday]

  belongs_to :professional

  validates :weekday, :starts_at, :ends_at, presence: true
  validates :interval_starts_at, :interval_ends_at, presence: true

  validates :starts_at, inclusion: { in: HOURS }
  validates :ends_at, inclusion: { in: HOURS }
  validates :interval_starts_at, inclusion: { in: HOURS }
  validates :interval_ends_at, inclusion: { in: HOURS }

  def self.weekday_attributes_for_select
    weekdays.map do |weekday, _|
      [I18n.t("activerecord.attributes.#{model_name.i18n_key}.weekdays.#{weekday}"), weekday]
    end
  end
end
