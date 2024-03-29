class Identity < OmniAuth::Identity::Models::ActiveRecord
  attr_accessor :name, :phone

  # Validations
  validates :email, uniqueness: true
  validates :email, :name, presence: true
end
