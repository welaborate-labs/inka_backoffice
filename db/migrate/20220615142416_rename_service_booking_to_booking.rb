class RenameServiceBookingToBooking < ActiveRecord::Migration[7.0]
  def change
    rename_table "service_bookings", "bookings"
  end
end
