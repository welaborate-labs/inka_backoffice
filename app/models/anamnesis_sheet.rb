class AnamnesisSheet < ApplicationRecord
  belongs_to :customer

  before_save :set_customer_attributes

  has_one_attached :file

  attr_writer :name, :birth_date, :document, :email, :gender, :phone
  attr_writer :street_address, :number, :district, :city, :state, :zip_code

  delegate :name, to: :customer
  delegate :birth_date, to: :customer
  delegate :document, to: :customer
  delegate :email, to: :customer
  delegate :gender, to: :customer
  delegate :phone, to: :customer
  delegate :street_address, to: :customer
  delegate :number, to: :customer
  delegate :district, to: :customer
  delegate :state, to: :customer
  delegate :city, to: :customer
  delegate :zip_code, to: :customer


  def set_customer_attributes
    customer.name = self.name if self.name
    customer.birth_date = self.birth_date if self.birth_date
    customer.document = self.document if self.document
    customer.email = self.email if self.email
    customer.gender = self.gender if self.gender
    customer.phone = self.phone if self.phone
    customer.number = self.number if self.number
    customer.district = self.district if self.district
    customer.state = self.state if self.state
    customer.city = self.city if self.city
    customer.zip_code = self.zip_code if self.zip_code
  end
end
