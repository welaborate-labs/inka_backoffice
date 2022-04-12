class IdentificationKey < ActiveRecord::Base
  attr_accessor :public_key

  validates :private_key, presence: true
  belongs_to :user, optional: true

  def public_key
    rsa_key = OpenSSL::PKey::RSA.new private_key
    public_key ||= rsa_key.public_key.to_pem
  end
end
