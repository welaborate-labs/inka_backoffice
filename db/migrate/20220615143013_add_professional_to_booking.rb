class AddProfessionalToBooking < ActiveRecord::Migration[7.0]
  def change
    add_reference :bookings, :professional, null: false, foreign_key: true
  end
end
