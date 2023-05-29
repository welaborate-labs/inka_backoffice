class GiftCard < ApplicationRecord
  belongs_to :gift_card_template, optional: true
  belongs_to :booking, optional: true
  belongs_to :bill, optional: true
  has_many :gifted_services, as: :gift
  has_many :services, through: :gifted_services

  accepts_nested_attributes_for :gifted_services, allow_destroy: true, reject_if: :all_blank

  def title
    @title ||= service&.title
  end

  def billing_price
    price ? price : calculated_billing_price
  end

  def calculated_billing_price
    services_price + template_services_price
  end

  def services_price
    @services_price ||= services.reduce(0) { |sum, service| sum += service.price }.to_f
  end

  def template_services_price
    @template_services_price ||= gift_card_template ? gift_card_template.billing_price : 0.0
  end
end
