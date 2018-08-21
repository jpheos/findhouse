class CreateCalendars < ActiveRecord::Migration[5.1]
  def change
    create_table :calendars, id: false, primary_key: :service_id  do |t|
      t.integer :service_id
      t.boolean :monday
      t.boolean :tuesday
      t.boolean :wednesday
      t.boolean :thursday
      t.boolean :friday
      t.boolean :saturday
      t.boolean :sunday

      t.timestamps
    end
  end
end
