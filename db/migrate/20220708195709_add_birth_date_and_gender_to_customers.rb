class AddBirthDateAndGenderToCustomers < ActiveRecord::Migration[7.0]
  def change
    add_column :customers, :birth_date, :date
    add_column :customers, :gender, :string
  end
end
