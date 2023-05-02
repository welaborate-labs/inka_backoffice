class GiftCard < ApplicationRecord
  belongs_to :booking, optional: true
end
