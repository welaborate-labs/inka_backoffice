class MakeProfessionalsUserIdNullable < ActiveRecord::Migration[7.0]
  def up
    change_column_null :professionals, :user_id, true
  end

  def down
    change_column_null :professionals, :user_id, false
  end
end
