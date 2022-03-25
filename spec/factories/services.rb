FactoryBot.define do
  factory :service do
    title { 'Title Service' }
    duration { 120 }
    price { 88 }
    is_comissioned { false }
    professional { nil }
  end
end
