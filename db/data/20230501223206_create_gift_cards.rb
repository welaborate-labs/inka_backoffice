# frozen_string_literal: true

class CreateGiftCards < ActiveRecord::Migration[7.0]
  def up
    100.times do
      GiftCard.create
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
