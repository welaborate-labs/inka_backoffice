FactoryBot.define do
  factory :timeslot do
    starts_at { '2022-05-10 08:00' }
    ends_at { '2022-05-10 17:00' }
    schedule
  end
end
