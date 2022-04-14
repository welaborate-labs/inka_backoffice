FactoryBot.define do
  factory :timeslot do
    starts_at { '2022-03-24 08:00' }
    ends_at { '2022-03-24 17:00' }
    schedule { nil }
  end
end
