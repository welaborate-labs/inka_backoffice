class Stock < ApplicationRecord
  belongs_to :product

  def balance_change
    raise NotImplementedError
  end
end
