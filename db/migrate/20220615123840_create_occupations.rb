class CreateOccupations < ActiveRecord::Migration[7.0]
  def change
    create_table :occupations do |t|
      t.references :professional, null: false, foreign_key: true
      t.references :service, null: false, foreign_key: true
      t.datetime :starts_at
      t.datetime :ends_at

      t.timestamps
    end
  end
end
