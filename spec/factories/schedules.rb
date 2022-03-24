FactoryBot.define do
  factory :schedule do
    weekday { 0 }
    starts_at { '07:00' }
    ends_at { '18:00' }
    interval_starts_at { '12:00' }
    interval_ends_at { '13:00' }
    professional { nil }
  end
end
