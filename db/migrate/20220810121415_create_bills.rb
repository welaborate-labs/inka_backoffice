class CreateBills < ActiveRecord::Migration[7.0]
  def change
    create_table :bills do |t|
      t.decimal :amount
      t.boolean :is_gift
      t.decimal :discount
      t.decimal :discounted_value
      t.string :state

      t.timestamps
    end
  end
end
