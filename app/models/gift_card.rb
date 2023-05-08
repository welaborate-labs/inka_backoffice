class GiftCard < ApplicationRecord
  belongs_to :gift_card_template, optional: true
  belongs_to :booking, optional: true
  belongs_to :bill, optional: true
  has_many :gifted_services, as: :gift
  has_many :services, through: :gifted_services

  accepts_nested_attributes_for :gifted_services, allow_destroy: true, reject_if: :all_blank
end
