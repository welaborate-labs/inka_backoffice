class ServiceBooking < ApplicationRecord
  belongs_to :customer
  belongs_to :timeslot

  validates :status, presence: :true

  enum status: %i[
         requested
         accepted
         confirmed
         customer_canceled
         professional_canceled
         absent
         completed
       ]
end
