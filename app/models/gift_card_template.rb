class GiftCardTemplate < ApplicationRecord
  has_many :gift_cards
  has_many :gift_card_template_services, dependent: :destroy
  has_many :services, through: :gift_card_template_services

  validates :name, presence: true
  validates :price, presence: true
end
