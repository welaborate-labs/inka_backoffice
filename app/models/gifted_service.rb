class GiftedService < ApplicationRecord
  belongs_to :gift, polymorphic: true
  belongs_to :service
end
