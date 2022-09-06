class CreateGiftCardTemplateServices < ActiveRecord::Migration[7.0]
  def change
    create_table :gift_card_template_services do |t|
      t.references :gift_card_template, null: true, foreign_key: true
      t.references :gift_card, null: true, foreign_key: true
      t.references :service, null: false, foreign_key: true

      t.timestamps
    end
  end
end
