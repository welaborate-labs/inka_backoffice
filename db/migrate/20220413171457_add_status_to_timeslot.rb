class AddStatusToTimeslot < ActiveRecord::Migration[7.0]
  def change
    add_column :timeslots, :status, :integer, default: 0
  end
end
