class AddBookingsToBill < ActiveRecord::Migration[7.0]
  def change
    add_reference :bookings, :bill, foreign_key: true
  end
end
