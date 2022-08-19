json.extract!(
  customer,
  :id,
  :name,
  :email,
  :phone,
  :street_address,
  :document,
  :avatar,
  :user_id,
  :birth_date,
  :gender,
  :number,
  :complement,
  :district,
  :state,
  :city,
  :zip_code,
  :created_at,
  :updated_at
)
json.url customer_url(customer, format: :json)
json.avatar url_for(customer.avatar)
