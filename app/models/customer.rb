class Customer < ApplicationRecord
  REGEX_FORMAT = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  has_one_attached :avatar

  belongs_to :user, optional: true
  has_many :bookings, dependent: :destroy
  has_many :bills, through: :bookings
  has_many :anamnesis_sheets, dependent: :destroy

  validates :name, presence: true
  validates :email, format: { with: REGEX_FORMAT }, allow_blank: true
  validates :email, :document, uniqueness: true, allow_blank: true
  validates :name, length: { within: 3..100 }, allow_blank: true
  validates :phone, length: { within: 8..15 }, allow_blank: true
  validates :document, length: { within: 10..16 }, allow_blank: true
  # validates :street_address, length: { within: 1..100 }, if: -> { address_validation }
  validates :complement, length: { within: 1..100 }, allow_blank: true
  validates :district, length: { within: 1..100 }, if: -> { address_validation }
  validates :state, length: { within: 2..2 }, if: -> { address_validation }

  scope :find_by_name, -> (query) { where("name ILIKE ?", "%#{query}%").select(:name, :id).order("name ASC").take(5) }

  def address_validation
    if street_address.present? ||
       number.present? ||
       complement.present? ||
       district.present? ||
       state.present?
      true
    else
      false
    end
  end

  def document_numbers
    @document_numbers ||= document.strip.gsub(/\.|\-|\//, '')
  end
end
