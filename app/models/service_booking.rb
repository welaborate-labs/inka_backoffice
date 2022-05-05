class ServiceBooking < ApplicationRecord
  before_save :update_canceledAt if status = 3 || status = 4

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

  def update_canceledAt
    self.canceledAt = DateTime.now
  end
end
