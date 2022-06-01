class ProductUsage < ApplicationRecord
  belongs_to :product
  belongs_to :service

  validates :quantity, presence: true
end
