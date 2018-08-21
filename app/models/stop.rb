class Stop < ApplicationRecord
  self.primary_key = :stop_id
  default_scope { where(location_type: 0).where("stop_id LIKE 'StopPoint:OCETrain%'") }

  geocoded_by :address, :latitude  => :stop_lat, :longitude => :stop_lon

  has_many :stop_times




  def get_stats_schedule(target_stop_ids, start_time, end_time)
    sql = "

      SELECT  stops.stop_name as gare_start,
              stop_times_main.departure_time::time as start_time,
              stops_lyon.stop_name as gare_end,
              stop_times_lyon.arrival_time::time as end_time,
              stop_times_main.trip_id,
              trips.service_id,
              calendars.monday
      FROM stops
      INNER JOIN stop_times as stop_times_main ON stop_times_main.stop_id = stops.stop_id
      INNER JOIN stop_times as stop_times_lyon ON stop_times_main.trip_id = stop_times_lyon.trip_id
      INNER JOIN stops as stops_lyon ON stop_times_lyon.stop_id = stops_lyon.stop_id
      INNER JOIN trips ON stop_times_main.trip_id = trips.trip_id
      INNER JOIN calendars ON calendars.service_id = trips.service_id
      WHERE stops.stop_id = '#{self.stop_id}'
        AND (stop_times_main.departure_time::time BETWEEN time '#{start_time}:00' and  time '#{end_time}:00')
        AND stop_times_lyon.stop_id IN (#{target_stop_ids.map{|s| "'#{s}'"}.join(',')})
        AND calendars.monday IS TRUE
        AND calendars.tuesday IS TRUE
        AND calendars.wednesday IS TRUE
        AND calendars.thursday IS TRUE
        AND calendars.friday IS TRUE
        AND stop_times_main.departure_time < stop_times_lyon.departure_time
      ORDER BY stop_times_main.departure_time, stop_times_lyon.arrival_time
    "
    results = ActiveRecord::Base.connection.exec_query(sql)
    tab = {}
    results.each do |result|
        h = tab[result["start_time"]] || {}
        h[result["end_time"]] = result["gare_end"]
        tab[result["start_time"]] = h
    end
    tab
  end

end
