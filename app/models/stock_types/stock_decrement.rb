class StockDecrement < Stock
  def balance_change
    -quantity
  end
end
