class CreateAnamnesisSheets < ActiveRecord::Migration[7.0]
  def change
    create_table :anamnesis_sheets do |t|
      t.text :title
      t.references :customer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
