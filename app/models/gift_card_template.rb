class GiftCardTemplate < ApplicationRecord
  has_many :gifted_services, as: :gift
  has_many :services, through: :gifted_services
  has_many :gift_cards

  accepts_nested_attributes_for :gifted_services, allow_destroy: true, reject_if: :all_blank

  def billing_price
    price ? price : services_price
  end

  def services_price
    @services_price ||= services.reduce(0) { |sum, service| sum += service.price }.to_f
  end
end
