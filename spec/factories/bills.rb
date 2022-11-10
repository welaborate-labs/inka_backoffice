FactoryBot.define do
  factory :bill do
    amount { nil }
    is_gift { false }
    discount { nil }
    discounted_value { nil }
    state { "MyString" }
    bookings { nil }
    status { 0 }
  end
end
