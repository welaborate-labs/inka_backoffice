FactoryBot.define do
  factory :user do
    provider { "identity" }
    uid { 1 }
    name { 'John Doe' }
    email { 'john.doe@example.com' }
    phone { '1199998888' }
  end
end
