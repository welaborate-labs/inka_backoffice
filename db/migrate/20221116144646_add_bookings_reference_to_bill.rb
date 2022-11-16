class AddBookingsReferenceToBill < ActiveRecord::Migration[7.0]
  def change
    add_column :bills, :bookings_reference, :integer, array: true
  end
end
