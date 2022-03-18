class Professional < ApplicationRecord
  include ActionView::Helpers::NumberHelper
  REGEX_FORMAT = /\A[\w+-.]+@[a-z\d-]+(.[a-z]+)*.[a-z]+\z/i

  has_one_attached :avatar, dependent: :destroy
  has_many :services
  belongs_to :user

  # Validations
  # presence
  validates :name, :email, :phone, :address, :document, :avatar, presence: true

  # format
  validates :email, format: { with: REGEX_FORMAT }, if: lambda { self.email.present? }

  #uniqueness
  validates :email, uniqueness: true, if: lambda { self.email.present? }
  validates :document, uniqueness: true, if: lambda { self.document.present? }

  # length within min..max
  validates :name, length: { within: 3..100 }, if: lambda { self.name.present? }
  validates :phone, length: { within: 8..15 }, if: lambda { self.phone.present? }
  validates :address, length: { within: 10..150 }, if: lambda { self.address.present? }
  validates :document, length: { within: 10..16 }, if: lambda { self.document.present? }
end
