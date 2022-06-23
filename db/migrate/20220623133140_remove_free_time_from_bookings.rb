class RemoveFreeTimeFromBookings < ActiveRecord::Migration[7.0]
  def change
    remove_column :bookings, :free_time, :integer
  end
end
