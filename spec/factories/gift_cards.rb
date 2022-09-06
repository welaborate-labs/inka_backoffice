FactoryBot.define do
  factory :gift_card do
    customer
    price { 321.12 }
    name { "Gift Card Name" }
    uuid { SecureRandom.uuid }
  end
end
