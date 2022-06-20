class User < ApplicationRecord
  has_one :professional, dependent: :destroy
  include ActionView::Helpers::NumberHelper
  REGEX_FORMAT = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  validates :provider, :uid, :email, :name, presence: true
  validates :email, format: { with: REGEX_FORMAT }
  validates :email, uniqueness: true
  validates :phone, length: { within: 8..15 }, allow_blank: true
  validates :name, length: { within: 3..100 }

  def self.find_or_create_from_hash(auth_hash)
    user = find_by(provider: auth_hash['provider'], uid: auth_hash['uid'])

    return user if user

    user = User.find_by(email: auth_hash['info']['email'])
  end

  def self.create_from_hash(auth_hash)
    user =
      create! do |user|
        user.uid = auth_hash['uid']
        user.provider = auth_hash['provider']
        user.name = auth_hash['info']['name']
        user.email = auth_hash['info']['email']
        user.phone = auth_hash['info']['phone']
      end
    user
  end

  # before_create do
  #   self.name = name.downcase.titleize
  #   self.phone =
  #     number_to_phone(phone.gsub(/\D/, ''), pattern: /(\d{2})(\d{4})(\d{4})$/, delimeter: '-')
  # end

  # before_update do
  #   self.name = name.downcase.titleize
  #   self.phone =
  #     number_to_phone(phone.gsub(/\D/, ''), pattern: /(\d{2})(\d{4})(\d{4})$/, delimeter: '-')
  # end
end
