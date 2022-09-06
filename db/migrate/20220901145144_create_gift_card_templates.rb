class CreateGiftCardTemplates < ActiveRecord::Migration[7.0]
  def change
    create_table :gift_card_templates do |t|
      t.decimal :price
      t.string :name

      t.timestamps
    end
  end
end
