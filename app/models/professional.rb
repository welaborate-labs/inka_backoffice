class Professional < ApplicationRecord
  REGEX_FORMAT = /\A[\w+-.]+@[a-z\d-]+(.[a-z]+)*.[a-z]+\z/i

  has_one_attached :avatar, dependent: :destroy
  has_many :schedules, dependent: :destroy
  has_many :occupations, dependent: :destroy
  has_many :services, through: :occupations
  has_many :bookings, dependent: :destroy
  belongs_to :user, optional: true

  accepts_nested_attributes_for :schedules, allow_destroy: true, reject_if: :all_blank

  validates :name, :email, presence: true
  validates :email, format: { with: REGEX_FORMAT }
  validates :email, uniqueness: true
  validates :document, uniqueness: true, allow_blank: true
  validates :name, length: { within: 3..100 }
  validates :phone, length: { within: 8..15 }, allow_blank: true
  validates :address, length: { within: 10..150 }, allow_blank: true
  validates :document, length: { within: 10..16 }, allow_blank: true
end
