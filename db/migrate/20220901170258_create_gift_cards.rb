class CreateGiftCards < ActiveRecord::Migration[7.0]
  def change
    create_table :gift_cards do |t|
      t.references :customer, null: false, foreign_key: true
      t.references :gift_card_template, null: true, foreign_key: true
      t.references :bill, null: true, foreign_key: true
      t.decimal :price
      t.string :name
      t.string :uuid

      t.timestamps
    end
  end
end
