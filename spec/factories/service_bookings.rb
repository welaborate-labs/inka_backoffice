FactoryBot.define do
  factory :service_booking do
    notes { 'some note' }
    status { 1 }
    canceledAt { '2022-04-12 11:15:41' }
    customer { nil }
    timeslot { nil }
  end
end
