class CreateIdentificationKeys < ActiveRecord::Migration[7.0]
  def change
    create_table :identification_keys do |t|
      t.string :private_key
      t.string :salt
      t.references :user, null: true, foreign_key: true

      t.timestamps
    end
  end
end
