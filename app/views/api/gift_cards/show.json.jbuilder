json.id @gift_card.id
json.name @gift_card.gift_card_template&.title
json.booked @gift_card.booking_id.present?
json.services (@gift_card.services + (@gift_card.gift_card_template&.services || [])), :id, :title
json.inline_items @gift_card.inline_items.to_s << @gift_card.gift_card_template&.inline_items.to_s
