class CreateSchedules < ActiveRecord::Migration[7.0]
  def change
    create_table :schedules do |t|
      t.integer :weekday
      t.string :starts_at
      t.string :ends_at
      t.string :interval_starts_at
      t.string :interval_ends_at
      t.references :professional, null: false, foreign_key: true

      t.timestamps
    end
  end
end
