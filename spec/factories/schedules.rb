FactoryBot.define do
  factory :schedule do
    weekday { 0 }
    starts_at { '8am' }
    ends_at { '18pm' }
    interval_starts_at { '12pm' }
    interval_ends_at { '13pm' }
    professional { nil }
  end
end
