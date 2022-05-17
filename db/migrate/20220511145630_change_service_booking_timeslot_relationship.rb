class ChangeServiceBookingTimeslotRelationship < ActiveRecord::Migration[7.0]
  def up
    add_reference :timeslots, :service_booking, foreign_key: true
    remove_reference :service_bookings, :timeslot, foreign_key: true
  end
end
