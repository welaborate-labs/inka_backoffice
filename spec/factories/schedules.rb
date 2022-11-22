FactoryBot.define do
  factory :schedule do
    weekday { 1 }
    starts_at { 10 }
    ends_at { 19 }
    interval_starts_at { 12 }
    interval_ends_at { 13 }
    professional
  end
end
