class CreateServiceBookings < ActiveRecord::Migration[7.0]
  def change
    create_table :service_bookings do |t|
      t.text :notes
      t.integer :status
      t.datetime :canceled_at
      t.references :customer, null: false, foreign_key: true
      t.references :timeslot, null: false, foreign_key: true

      t.timestamps
    end
  end
end
