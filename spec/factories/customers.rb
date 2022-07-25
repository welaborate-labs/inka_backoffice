FactoryBot.define do
  factory :customer do
    name { "John Doe" }
    email { "john.doe@example.com" }
    phone { "1199998888" }
    address { "John Doe of Jane Doe Adrress" }
    document { "12345678909" }
    user { nil }
    avatar { nil }
  end

  trait :with_avatar do
    after :build do |customer|
      file_name = "model.png"
      file_path = Rails.root.join("spec", "fixtures", "files", file_name)
      customer.avatar.attach(io: File.open(file_path), filename: file_name)
    end
  end
end
