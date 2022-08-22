require "services/focus_nfe_api"

class Bill < ApplicationRecord
  has_many :bookings

  validate :booking_validation
  validates :justification, length: { within: 2..150 }, on: :destroy

  before_save :calculate_amount
  before_save :calculate_discounted_value, if: -> { discount.present? }
  before_destroy :remove_relationships

  after_save :create_nfse

  def calculate_amount
    self.amount = bookings.map { |booking| booking.service.price }.join.to_f
  end

  def calculate_discounted_value
    self.discounted_value = (self.amount * (self.discount.to_f / 100)).ceil
  end

  def create_nfse
    CreateNfseJob.perform_later(self)
  end

  def get_pdf
    FocusNfeApi.new(self).get_url("url")
  end

  def get_xml
    FocusNfeApi.new(self).get_url("caminho_xml_nota_fiscal")
  end

  def remove_relationships
    self.bookings.update!(bill_id: nil)
  end

  private

  def booking_validation
    if bookings.empty?
      errors.add(:bookings, 'não pode ficar em branco.')
    end
  end
end
