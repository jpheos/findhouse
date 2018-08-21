class CreateTrips < ActiveRecord::Migration[5.1]
  def change
    create_table :trips, id: false, primary_key: :trip_id do |t|
      t.string :trip_id
      t.integer :service_id
      t.string :route_id
      t.integer :trip_headsign
      t.integer :direction_id

      t.timestamps
    end
  end
end
