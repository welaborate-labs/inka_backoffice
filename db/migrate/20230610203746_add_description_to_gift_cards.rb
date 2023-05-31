class AddDescriptionToGiftCards < ActiveRecord::Migration[7.0]
  def change
    add_column :gift_cards, :description, :string
  end
end
