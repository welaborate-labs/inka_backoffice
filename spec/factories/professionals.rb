FactoryBot.define do
  factory :professional do
    name { "John Doe" }
    sequence :email do |n|
      "john.doe#{n}@example.com"
    end
    phone { "1199998888" }
    address { "Some Address" }
    sequence :document do |n|
      "6665554443#{n}"
    end
    avatar { nil }
    user
  end
end
