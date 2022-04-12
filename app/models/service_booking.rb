class ServiceBooking < ApplicationRecord
  enum status: %i[
         requested
         accepted
         confirmed
         customer_canceled
         professional_canceled
         absent
         completed
       ]

  belongs_to :customer
  belongs_to :timeslot

  validates :status, presence: :true
end
