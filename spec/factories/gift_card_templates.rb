FactoryBot.define do
  factory :gift_card_template do
    title { "MyString" }
    description { "MyText" }
    price { "9.99" }
    inline_items { "MyText" }
  end
end
