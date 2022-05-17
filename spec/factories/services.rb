FactoryBot.define do
  factory :service do
    title { 'Title Service' }
    duration { 30 }
    price { 88 }
    is_comissioned { false }
    professional
  end
end
