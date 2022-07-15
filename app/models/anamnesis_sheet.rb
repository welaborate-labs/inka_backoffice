class AnamnesisSheet < ApplicationRecord
  belongs_to :customer

  before_save :set_customer_attributes

  has_one_attached :file

  attr_writer :name, :address, :birth_date, :document, :email, :gender, :phone

  delegate :name, to: :customer
  delegate :address, to: :customer
  delegate :birth_date, to: :customer
  delegate :document, to: :customer
  delegate :email, to: :customer
  delegate :gender, to: :customer
  delegate :phone, to: :customer

  def set_customer_attributes
    customer.name = self.name if self.name
    customer.address = self.address if self.address
    customer.birth_date = self.birth_date if self.birth_date
    customer.document = self.document if self.document
    customer.email = self.email if self.email
    customer.gender = self.gender if self.gender
    customer.phone = self.phone if self.phone
  end
end
