class Stock < ApplicationRecord
  scope :stock_increments, -> { where(type: 'StockIncrement') }
  scope :stock_decrements, -> { where(type: 'StockDecrement') }

  belongs_to :product

  validates :type, :quantity, :integralized_at, presence: true

  def balance_change
    raise NotImplementedError
  end
end
