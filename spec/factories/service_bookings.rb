FactoryBot.define do
  factory :service_booking do
    notes { 'some note' }
    status { 1 }
    canceled_at { nil }
    customer
    service
    booking_datetime { '2022-05-09 09:00' }
  end
end
