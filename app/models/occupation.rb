class Occupation < ApplicationRecord
  belongs_to :professional
  belongs_to :service
end
