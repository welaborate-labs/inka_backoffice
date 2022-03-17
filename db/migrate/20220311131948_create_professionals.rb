class CreateProfessionals < ActiveRecord::Migration[7.0]
  def change
    create_table :professionals do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.string :address
      t.string :document
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
