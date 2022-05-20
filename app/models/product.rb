class Product < ApplicationRecord
  has_many :stocks, dependent: :destroy
  has_many :product_usages, dependent: :destroy

  enum unit: %i[Kilograma Litro]

  def stock_balance
    @stock_balance ||= stocks.reduce { |sum, stock| sum + stock.balance_change }
  end
end
