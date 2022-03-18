class CreateServices < ActiveRecord::Migration[7.0]
  def change
    create_table :services do |t|
      t.string :title
      t.integer :duration
      t.integer :price
      t.boolean :is_comissioned, default: false
      t.references :professional, null: false, foreign_key: true
      # t.references :service, foreign_key: { to_table: :services }
      t.belongs_to :service, foreign_key: true, null: true
      t.timestamps
    end
  end
end
