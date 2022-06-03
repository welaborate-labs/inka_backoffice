class Service < ApplicationRecord
  belongs_to :professional
  belongs_to :service, class_name: 'Service', optional: true

  has_many :service_bookings, dependent: :destroy
  has_many :optional_services,
           class_name: 'Service',
           foreign_key: 'service_id',
           dependent: :destroy
  has_many :product_usages, dependent: :destroy

  validates :title, :duration, :price, presence: true
  validates :title, length: { within: 3..50 }
  validates :is_comissioned, inclusion: { in: [true, false] }

  accepts_nested_attributes_for :product_usages, allow_destroy: true, reject_if: :all_blank
end
