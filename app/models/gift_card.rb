class GiftCard < ApplicationRecord
  belongs_to :booking, optional: true
  has_many :gifted_services
  has_many :services, through: :gifted_services

  accepts_nested_attributes_for :gifted_services, allow_destroy: true, reject_if: :all_blank
end
