class Service < ApplicationRecord
  belongs_to :professional

  has_many :optional_services,
           class_name: 'Service',
           foreign_key: 'service_id',
           dependent: :destroy
  belongs_to :service, class_name: 'Service', optional: true

  # Validations
  ## Presence
  validates_presence_of :title, :duration, :price
  validates_inclusion_of :is_comissioned, in: [true, false, 0, 1], message: "can't be blank"

  # length within min..max
  validates :title, length: { within: 3..50 }, if: lambda { self.title.present? }
  validates :duration, length: { maximum: 15 }, if: lambda { self.duration.present? }
end
