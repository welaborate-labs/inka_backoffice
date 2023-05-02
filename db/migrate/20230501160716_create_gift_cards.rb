class CreateGiftCards < ActiveRecord::Migration[7.0]
  def change
    create_table :gift_cards, id: :uuid do |t|
      t.belongs_to :booking, foreign_key: true
      t.belongs_to :bill, foreign_key: true
      t.decimal :price

      t.timestamps
    end
  end
end
