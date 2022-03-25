class CreateTimeslots < ActiveRecord::Migration[7.0]
  def change
    create_table :timeslots do |t|
      t.datetime :starts_at
      t.datetime :ends_at
      t.references :schedule, null: false, foreign_key: true

      t.timestamps
    end
  end
end
