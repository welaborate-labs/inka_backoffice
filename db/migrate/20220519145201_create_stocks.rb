class CreateStocks < ActiveRecord::Migration[7.0]
  def change
    create_table :stocks do |t|
      t.belongs_to :product, null: false, foreign_key: true
      t.integer :quantity
      t.string :type, null: false
      t.datetime :integralized_at

      t.timestamps
    end
  end
end
