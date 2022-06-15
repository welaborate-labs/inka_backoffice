class Customer < ApplicationRecord
  has_one_attached :avatar
  REGEX_FORMAT = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  has_many :bookings, dependent: :destroy

  validates :name, :email, :phone, :address, :document, :avatar, presence: true
  validates :email, format: { with: REGEX_FORMAT }
  validates :email, :document, uniqueness: true
  validates :name, length: { within: 3..100 }
  validates :phone, length: { within: 8..15 }
  validates :address, length: { within: 10..150 }
  validates :document, length: { within: 10..16 }
end
