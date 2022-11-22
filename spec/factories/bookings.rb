FactoryBot.define do
  factory :booking do
    notes { 'some note' }
    status { 1 }
    canceled_at { nil }
    customer
    service
    starts_at { '2022-05-09 10:00' }
  end
end
