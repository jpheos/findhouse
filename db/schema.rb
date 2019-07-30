# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_07_30_130221) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "calendars", id: false, force: :cascade do |t|
    t.integer "service_id"
    t.boolean "monday"
    t.boolean "tuesday"
    t.boolean "wednesday"
    t.boolean "thursday"
    t.boolean "friday"
    t.boolean "saturday"
    t.boolean "sunday"
  end

  create_table "stations", force: :cascade do |t|
    t.string "name"
    t.float "latitude"
    t.float "longitude"
    t.integer "zipcode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stop_times", id: false, force: :cascade do |t|
    t.string "trip_id"
    t.time "arrival_time"
    t.time "departure_time"
    t.string "stop_id"
    t.integer "stop_sequence"
    t.string "stop_headsign"
    t.integer "pickup_type"
    t.integer "drop_off_type"
    t.string "shape_dist_traveled"
  end

  create_table "stops", id: false, force: :cascade do |t|
    t.string "stop_id"
    t.string "stop_name"
    t.string "stop_desc"
    t.float "stop_lat"
    t.float "stop_lon"
    t.string "zone_id"
    t.string "stop_url"
    t.string "location_type"
    t.string "parent_station"
  end

  create_table "trips", id: false, force: :cascade do |t|
    t.string "trip_id"
    t.integer "service_id"
    t.string "route_id"
    t.integer "trip_headsign"
    t.integer "direction_id"
  end

end
