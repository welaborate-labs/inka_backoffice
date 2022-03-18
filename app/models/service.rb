class Service < ApplicationRecord
  belongs_to :professional

  # has_many :subordinates, class_name: 'Service', foreign_key: 'manager_id'
  # belongs_to :manager, class_name: 'Service', optional: true

  has_many :optional_services,
           class_name: 'Service',
           foreign_key: 'service_id',
           dependent: :destroy
  belongs_to :service, class_name: 'Service', optional: true

  # Validations
  ## Presence
  validates_presence_of :title, :duration, :price
  validates_inclusion_of :is_comissioned, in: [true, false], message: "can't be blank"
end
