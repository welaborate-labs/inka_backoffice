FactoryBot.define do
  factory :bill do
    amount { "9.99" }
    is_gift { false }
    discount { "9.99" }
    discounted_value { "9.99" }
    state { "MyString" }
  end
end
