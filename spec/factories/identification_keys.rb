FactoryBot.define do
  factory :identification_key do
    private_key { OpenSSL::PKey::RSA.new(512).to_pem }
    user { nil }
  end
end
