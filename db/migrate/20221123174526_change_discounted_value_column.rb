class ChangeDiscountedValueColumn < ActiveRecord::Migration[7.0]
  def change
    change_column :bills, :discounted_value, :decimal, precision: 10, scale: 2, default: 0.0
    change_column :bills, :discount, :integer, default: 0
  end
end
