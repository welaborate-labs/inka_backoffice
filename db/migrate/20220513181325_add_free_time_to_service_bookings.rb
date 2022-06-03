class AddFreeTimeToServiceBookings < ActiveRecord::Migration[7.0]
  def change
    add_column :service_bookings, :free_time, :integer
  end
end
