json.extract! professional, :id, :name, :email, :phone, :address, :document, :avatar, :user_id, :created_at, :updated_at
json.url professional_url(professional, format: :json)
json.avatar url_for(professional.avatar)
