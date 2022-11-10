FactoryBot.define do
  factory :user do
    provider { "identity" }
    uid { 1 }
    name { "John Doe" }
    sequence :email do |n|
      "john.doe#{n}@example.com"
    end
    phone { "1199998888" }
  end
end
