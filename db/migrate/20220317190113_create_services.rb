class CreateServices < ActiveRecord::Migration[7.0]
  def change
    create_table :services do |t|
      t.string :title
      t.integer :duration
      t.decimal :price, precision: 8, scale: 2
      t.boolean :is_comissioned, default: false
      t.references :professional, null: false, foreign_key: true
      t.belongs_to :service, foreign_key: true, null: true
      t.timestamps
    end
  end
end
