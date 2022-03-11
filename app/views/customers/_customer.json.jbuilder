json.extract! customer, :id, :name, :email, :phone, :address, :document, :avatar, :created_at, :updated_at
json.url customer_url(customer, format: :json)
json.avatar url_for(customer.avatar)
