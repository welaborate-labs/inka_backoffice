class CreateGiftCardTemplates < ActiveRecord::Migration[7.0]
  def change
    create_table :gift_card_templates, id: :uuid do |t|
      t.string :title
      t.text :description
      t.decimal :price
      t.text :inline_items

      t.timestamps
    end
  end
end
