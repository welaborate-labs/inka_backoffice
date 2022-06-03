class AddServiceReferenceToServiceBookings < ActiveRecord::Migration[7.0]
  def change
    add_reference :service_bookings, :service, foreign_key: true
  end
end
