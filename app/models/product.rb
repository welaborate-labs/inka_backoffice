class Product < ApplicationRecord
  has_many :stocks
  has_many :product_usages

  def stock_balance
    @stock_balance ||= stocks.reduce { |sum, stock| sum + stock.balance_change }
  end
end
