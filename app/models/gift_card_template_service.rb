class GiftCardTemplateService < ApplicationRecord
  belongs_to :gift_card_template, optional: true
  belongs_to :gift_card, optional: true
  belongs_to :service, optional: true
end
