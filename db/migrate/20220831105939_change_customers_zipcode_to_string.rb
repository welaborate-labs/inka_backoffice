class ChangeCustomersZipcodeToString < ActiveRecord::Migration[7.0]
  def up
    change_column :customers, :zip_code, :string
  end

  def down
    change_column :customers, :zip_code, 'integer USING CAST(zip_code AS integer)'
  end
end
