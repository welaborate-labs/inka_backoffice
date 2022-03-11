class User < ApplicationRecord
  has_one :professional, dependent: :destroy
  include ActionView::Helpers::NumberHelper
  REGEX_FORMAT = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  # Validations
  # presence
  validates :provider, :uid, :email, :name, :phone, presence: true

  # format
  validates :email, format: { with: REGEX_FORMAT }, if: lambda { self.email.present? }

  # uniqueness
  validates :email, uniqueness: true, if: lambda { self.email.present? }

  #length within min..max
  validates :phone, length: { within: 8..15 }, if: lambda { self.phone.present? }
  validates :name, length: { within: 3..100 }, if: lambda { self.name.present? }

  def self.from_omniauth(auth)
    find_by_provider_and_uid(auth['provider'], auth['uid']) || create_with_omniauth(auth)
  end

  def self.create_with_omniauth(auth)
    user =
      create! do |user|
        user.uid = auth['uid']
        user.provider = auth['provider']
        user.name = auth['info']['name']
        user.email = auth['info']['email']
        user.phone = auth['info']['phone']
      end
  end

  # Hooks
  before_create do
    self.name = name.downcase.titleize
    self.phone =
      number_to_phone(self.phone.gsub(/\D/, ''), pattern: /(\d{2})(\d{4})(\d{4})$/, delimeter: '-')
  end

  before_update do
    self.name = name.downcase.titleize
    self.phone =
      number_to_phone(self.phone.gsub(/\D/, ''), pattern: /(\d{2})(\d{4})(\d{4})$/, delimeter: '-')
  end
end
