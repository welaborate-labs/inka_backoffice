FactoryBot.define do
  factory :service do
    title { 'Title Service' }
    duration { 60 }
    price { 88 }
    is_comissioned { false }
  end
end
