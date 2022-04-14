class AddStatusToTimeslot < ActiveRecord::Migration[7.0]
  def change
    add_column :timeslots, :status, :integer
  end
end
