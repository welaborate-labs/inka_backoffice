FactoryBot.define do
  factory :customer do
    name { "John Doe" }
    email { "john.doe@example.com" }
    phone { "1199998888" }
    document { "12345678909" }
    user { nil }
    avatar { nil }
    street_address { "John Doe's Address" }
    number { 1988 }
    complement { "House B" }
    district { "Doe's District" }
    city { "Mogi das Cruzes" }
    state { "SP" }
  end

  trait :with_avatar do
    after :build do |customer|
      file_name = "model.png"
      file_path = Rails.root.join("spec", "fixtures", "files", file_name)
      customer.avatar.attach(io: File.open(file_path), filename: file_name)
    end
  end
end
