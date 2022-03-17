FactoryBot.define do
  pass = BCrypt::Password.create('secret')
  factory :identity do
    name { 'John Doe' }
    email { 'john.doe@example.com' }
    phone { '1199998888' }
    password_digest { pass }
  end
end
