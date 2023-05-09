json.id @gift_card.id
json.name @gift_card.gift_card_template&.name
json.booked @gift_card.booking_id.present?
json.services((@gift_card.services + (@gift_card.gift_card_template&.services || [])), :id, :title)
