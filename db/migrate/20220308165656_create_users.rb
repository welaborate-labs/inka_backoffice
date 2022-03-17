class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :provider
      t.integer :uid
      t.string :name
      t.string :email
      t.string :phone

      t.timestamps
    end
  end
end
