FactoryBot.define do
  factory :gifted_service do
    gift_card { nil }
    service { nil }
    discount { "9.99" }
    price_override { "9.99" }
  end
end
