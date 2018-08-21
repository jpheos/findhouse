require 'csv'

# # STOPS
# filename = "#{File.dirname(__FILE__)}/data/stops.csv"


# CSV.foreach(filename, :headers => true).with_index do |row, i|
#   Stop.create!(row.to_hash)
#   ap i
# end

# # STOPTIMES
# filename = "#{File.dirname(__FILE__)}/data/stop_times.csv"
# interisting_stations = Stop.near("Lyon", 50).select {|s| s.stop_id.split().first.split(":").last == "OCETrain"}.map(&:stop_id)
# StopTime.delete_all
# CSV.foreach(filename, :headers => true).with_index do |row, i|
#   StopTime.create!(row.to_hash) if interisting_Sstations.include? row["stop_id"]
#   ap i if i % 500 == 0
# end

# TRIPS
filename = "#{File.dirname(__FILE__)}/data/trips.csv"
Trip.delete_all
CSV.foreach(filename, :headers => true).with_index do |row, i|
  Trip.create!({
          :trip_id => row['trip_id'],
       :service_id => row['service_id'],
         :route_id => row['route_id'],
    :trip_headsign => row['trip_headsign'],
     :direction_id => row['direction_id']
  })
end


# CALENDAR
filename = "#{File.dirname(__FILE__)}/data/calendar.csv"
Calendar.delete_all
CSV.foreach(filename, :headers => true).with_index do |row, i|
  Calendar.create!({
   :service_id =>  row['service_id'],
        :monday => row['monday'] == '1',
       :tuesday => row['tuesday'] == '1',
     :wednesday => row['wednesday'] == '1',
      :thursday => row['thursday'] == '1',
        :friday => row['friday'] == '1',
      :saturday => row['saturday'] == '1',
        :sunday => row['sunday'] == '1'
  })
end
