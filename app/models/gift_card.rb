class GiftCard < ApplicationRecord
  belongs_to :customer
  belongs_to :gift_card_template, optional: true
  belongs_to :bill, optional: true

  has_many :gift_card_template_services, dependent: :destroy
  has_many :services, through: :gift_card_template_services
  has_many :bookings

  before_create :generate_uuid

  def customer_name
    Customer.find(customer_id)&.name
  end

  private

  def generate_uuid
    uuid = SecureRandom.uuid
  end
end
