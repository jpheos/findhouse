class CreateStopTimes < ActiveRecord::Migration[5.1]
  def change
    create_table :stop_times, id: false, primary_key: [:trip_id, :stop_id] do |t|
      t.string :trip_id
      t.datetime :arrival_time
      t.datetime :departure_time
      t.string :stop_id
      t.integer :stop_sequence
      t.string :stop_headsign
      t.integer :pickup_type
      t.integer :drop_off_type
      t.string :shape_dist_traveled

      t.timestamps
    end
  end
end
