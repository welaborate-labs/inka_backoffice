class Professional < ApplicationRecord
  REGEX_FORMAT = /\A[\w+-.]+@[a-z\d-]+(.[a-z]+)*.[a-z]+\z/i

  has_one_attached :avatar, dependent: :destroy
  has_many :services, dependent: :destroy
  has_many :schedules, dependent: :destroy
  has_many :timeslots, through: :schedules, dependent: :destroy
  belongs_to :user

  accepts_nested_attributes_for :schedules, allow_destroy: true, reject_if: :all_blank

  validates :name, :email, :phone, :address, :document, presence: true
  validates :email, format: { with: REGEX_FORMAT }
  validates :email, uniqueness: true
  validates :document, uniqueness: true
  validates :name, length: { within: 3..100 }
  validates :phone, length: { within: 8..15 }
  validates :address, length: { within: 10..150 }
  validates :document, length: { within: 10..16 }
end
