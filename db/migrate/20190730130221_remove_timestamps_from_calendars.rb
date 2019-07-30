class RemoveTimestampsFromCalendars < ActiveRecord::Migration[5.2]
  def change
    remove_column :calendars, :created_at, :string
    remove_column :calendars, :updated_at, :string
  end
end
