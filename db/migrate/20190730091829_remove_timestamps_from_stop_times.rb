class RemoveTimestampsFromStopTimes < ActiveRecord::Migration[5.2]
  def change
    remove_column :stop_times, :created_at, :datetime
    remove_column :stop_times, :updated_at, :datetime
  end
end
