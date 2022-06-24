class RemoveProfessionalRelationFromServices < ActiveRecord::Migration[7.0]
  def change
    remove_reference :services, :professional, null: false, foreign_key: true
  end
end
