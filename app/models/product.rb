class Product < ApplicationRecord
  has_many :stocks, dependent: :destroy
  has_many :product_usages, dependent: :destroy

  enum unit: %i[mg kg ml l unidade]

  validates :name, :unit, presence: true

  scope :query_by_name, -> (query) { where("name ILIKE ?", "%#{query}%") }

  def stock_balance
    stocks.reduce(0) { |sum, stock| sum + stock.balance_change }
  end

  def name_and_unit
    "#{name} (#{unit})"
  end
end
