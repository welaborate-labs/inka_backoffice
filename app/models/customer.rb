class Customer < ApplicationRecord
  has_one_attached :avatar
  REGEX_FORMAT = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  belongs_to :user

  has_many :bookings, dependent: :destroy
  has_many :anamnesis_sheets, dependent: :destroy

  validates :name, :phone, presence: true
  validates :email, format: { with: REGEX_FORMAT }, allow_blank: true
  validates :email, :document, uniqueness: true, allow_blank: true
  validates :name, length: { within: 3..100 }, allow_blank: true
  validates :phone, length: { within: 8..15 }, allow_blank: true
  validates :address, length: { within: 10..150 }, allow_blank: true
  validates :document, length: { within: 10..16 }, allow_blank: true
end
