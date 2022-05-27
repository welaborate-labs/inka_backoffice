class Product < ApplicationRecord
  has_many :stocks, dependent: :destroy
  has_many :product_usages, dependent: :destroy

  enum unit: %i[kilograma litro]

  validates :name, :sku, :unit, presence: true

  def stock_balance
    stocks.reduce(0) { |sum, stock| sum + stock.balance_change }
  end
end
