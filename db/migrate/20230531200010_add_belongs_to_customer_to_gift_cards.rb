class AddBelongsToCustomerToGiftCards < ActiveRecord::Migration[7.0]
  def change
    add_reference :gift_cards, :customer, null: true, foreign_key: true
  end
end
