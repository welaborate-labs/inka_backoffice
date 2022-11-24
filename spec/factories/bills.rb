FactoryBot.define do
  factory :bill do
    amount { 50 }
    is_gift { false }
    discount { 10 }
    discounted_value { 20 }
    state { "MyString" }
    bookings { nil }
    status { 0 }
  end
end
