class Stock < ApplicationRecord
  scope :stock_increments, -> { where(type: 'StockIncrement') }
  scope :stock_decrements, -> { where(type: 'StockDecrement') }

  belongs_to :product

  validates :type, :quantity, :integralized_at, presence: true

  def balance_change
    raise NotImplementedError
  end

  def get_type_formatted
    return 'Entrada' if type == 'StockIncrement'
    return 'Saida' if type == 'StockDecrement'
  end
end
