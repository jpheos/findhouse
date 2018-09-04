require 'csv'

# STOPS
Stop.delete_all
filename = "#{File.dirname(__FILE__)}/data/stops.csv"
CSV.foreach(filename, :headers => true).with_index do |row, i|
  Stop.create!(row.to_hash)
  ap i
end

# STOPTIMES
filename = "#{File.dirname(__FILE__)}/data/stop_times.csv"
interisting_lyon_stations = Stop.near("Lyon", 80).select {|s| s.stop_id.split().first.split(":").last == "OCETrain"}.map(&:stop_id)
interisting_nantes_stations = Stop.near("Nantes", 80).select {|s| s.stop_id.split().first.split(":").last == "OCETrain"}.map(&:stop_id)
interisting_toulouse_stations = Stop.near("Toulouse", 80).select {|s| s.stop_id.split().first.split(":").last == "OCETrain"}.map(&:stop_id)
interisting_stations = interisting_lyon_stations + interisting_nantes_stations# + interisting_toulouse_stations

Stop.where.not(stop_id: interisting_stations).delete_all

StopTime.delete_all
CSV.foreach(filename, :headers => true).with_index do |row, i|
  StopTime.create!(row.to_hash) if interisting_stations.include? row["stop_id"]
  ap i if i % 500 == 0
end

# TRIPS
filename = "#{File.dirname(__FILE__)}/data/trips.csv"
Trip.delete_all
CSV.foreach(filename, :headers => true).with_index do |row, i|
  next unless StopTime.where(trip_id: row['trip_id']).exists?
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
  next unless %w(monday tuesday wednesday thursday friday).all? { |day| row[day] == '1' }
  next unless Trip.where(service_id: row['service_id']).exists?
  Calendar.create!({
   :service_id =>  row['service_id'],
        :monday => true,
       :tuesday => true,
     :wednesday => true,
      :thursday => true,
        :friday => true,
      :saturday => row['saturday'] == '1',
        :sunday => row['sunday'] == '1'
  })
end


