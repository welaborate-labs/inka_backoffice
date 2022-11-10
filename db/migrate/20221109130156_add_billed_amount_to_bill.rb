class AddBilledAmountToBill < ActiveRecord::Migration[7.0]
  def change
    add_column :bills, :billed_amount, :decimal
  end
end
