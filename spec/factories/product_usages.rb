FactoryBot.define do
  factory :product_usage do
    product
    service
    quantity { 1 }
  end
end
