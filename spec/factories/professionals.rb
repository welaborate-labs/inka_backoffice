FactoryBot.define do
  factory :professional do
    name { 'John Doe' }
    email { 'john.doe@example.com' }
    phone { '1199998888' }
    address { 'Some Address' }
    document { '99988877755' }
    avatar { nil }
    user
  end
end
