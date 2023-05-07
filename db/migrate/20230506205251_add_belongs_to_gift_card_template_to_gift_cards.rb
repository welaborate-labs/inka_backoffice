class AddBelongsToGiftCardTemplateToGiftCards < ActiveRecord::Migration[7.0]
  def change
    add_reference :gift_cards, :gift_card_template, foreign_key: true, type: :uuid, null: true
  end
end
