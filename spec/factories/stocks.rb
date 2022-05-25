FactoryBot.define do
  factory :stock do
    product
    quantity { 1 }
    type { '' }
    integralized_at { '2022-05-25' }
  end
end
