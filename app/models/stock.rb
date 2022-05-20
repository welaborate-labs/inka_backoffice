class Stock < ApplicationRecord
  attr_accessor :stock_type

  belongs_to :product

  def balance_change
    raise NotImplementedError
  end
end
