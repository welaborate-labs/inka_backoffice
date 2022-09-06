json.extract! gift_card, :id, :customer_id, :gift_card_template_id, :bill_id, :price, :name, :uuid, :created_at, :updated_at
json.url gift_card_url(gift_card, format: :json)
