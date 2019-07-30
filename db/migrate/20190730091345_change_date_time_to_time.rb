class ChangeDateTimeToTime < ActiveRecord::Migration[5.2]
  def up
    change_column :stop_times, :arrival_time, :time
    change_column :stop_times, :departure_time, :time
  end

  def down
    change_column :stop_times, :arrival_time, :datetime
    change_column :stop_times, :departure_time, :datetime
  end
end

