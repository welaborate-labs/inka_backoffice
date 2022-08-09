class AddNumberComplementDistrictStateCityAndZipCodeToCustomer < ActiveRecord::Migration[7.0]
  def change
    rename_column :customers, :address, :street_address
    add_column :customers, :number, :integer
    add_column :customers, :complement, :string
    add_column :customers, :district, :string
    add_column :customers, :state, :string
    add_column :customers, :city, :string
    add_column :customers, :zip_code, :integer
  end
end
