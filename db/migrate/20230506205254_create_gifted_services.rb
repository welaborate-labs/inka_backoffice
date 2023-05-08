class CreateGiftedServices < ActiveRecord::Migration[7.0]
  def change
    create_table :gifted_services do |t|
      t.uuid :gift_id, null: false
      t.string :gift_type, null: false
      t.belongs_to :service, null: false, foreign_key: true
      t.decimal :discount
      t.decimal :price_override

      t.timestamps
    end
  end
end
