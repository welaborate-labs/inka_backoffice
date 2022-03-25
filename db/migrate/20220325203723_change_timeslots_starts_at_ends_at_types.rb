class ChangeTimeslotsStartsAtEndsAtTypes < ActiveRecord::Migration[7.0]
  def up
    change_column :schedules, :starts_at, :integer, using: 'starts_at::integer'
    change_column :schedules, :ends_at, :integer, using: 'ends_at::integer'
    change_column :schedules, :interval_starts_at, :integer, using: 'interval_starts_at::integer'
    change_column :schedules, :interval_ends_at, :integer, using: 'interval_ends_at::integer'
  end

  def down
    change_column :schedules, :starts_at, :string
    change_column :schedules, :ends_at, :string
    change_column :schedules, :interval_starts_at, :string
    change_column :schedules, :interval_ends_at, :string
  end
end
