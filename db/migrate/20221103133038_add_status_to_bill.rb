class AddStatusToBill < ActiveRecord::Migration[7.0]
  def change
    add_column :bills, :status, :integer
  end
end
