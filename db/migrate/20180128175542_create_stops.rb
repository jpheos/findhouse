class CreateStops < ActiveRecord::Migration[5.1]
  def change
    create_table :stops, id: false do |t|
      t.string :stop_id, primary: true
      t.string :stop_name
      t.string :stop_desc
      t.float :stop_lat
      t.float :stop_lon
      t.string :zone_id
      t.string :stop_url
      t.string :location_type
      t.string :parent_station

      t.timestamps
    end
  end
end
