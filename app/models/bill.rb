class Bill < ApplicationRecord
  has_many :bookings, dependent: :destroy

  validate :check_bookings

  before_save :calculate_amount
  before_save :calculate_discounted_value, if: -> { discount.present? }

  after_save :create_nfse

  def calculate_amount
    self.amount = bookings.map { |booking| booking.service.price }.join
  end

  def calculate_discounted_value
    self.discounted_value = 0 if !self.discounted_value
    self.discounted_value = (self.amount * (self.discount.to_f / 100)).ceil
  end

  def create_nfse
    CreateNfseJob.perform_later(self)
  end

  private

  def check_bookings
    if bookings.empty?
      errors.add(:bookings, 'não pode ficar em branco.')
    end
  end
end
