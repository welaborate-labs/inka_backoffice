class AddInlineItemsToGiftCards < ActiveRecord::Migration[7.0]
  def change
    add_column :gift_cards, :inline_items, :text
  end
end
