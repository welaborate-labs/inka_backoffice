class Product < ApplicationRecord
  has_many :stocks, dependent: :destroy
  has_many :product_usages, dependent: :destroy

  enum unit: %i[mg kg ml l unidade]

  validates :name, :unit, presence: true

  def stock_balance
    stocks.reduce(0) { |sum, stock| sum + stock.balance_change }
  end
end
