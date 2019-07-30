filename = File.join(__dir__, 'data/stops.csv')

ap "DELETE STOPS"
Stop.delete_all

ap "CREATE STOPS"
sql = <<-SQL
  COPY public.stops (stop_id, stop_name, stop_desc, stop_lat, stop_lon, zone_id, stop_url, location_type, parent_station)
  FROM '#{filename}'
  DELIMITER ','
  CSV HEADER QUOTE '"'
SQL
ActiveRecord::Base.connection.execute(sql)
ap "STOPS CREATED"

ap "DELETE EXTRA STOPS"
Stop.where.not("stop_id ILIKE '%OCETrain%'").delete_all


# STOPTIMES
filename = File.join(__dir__, 'data/stop_times.csv')

ap "DELETE STOP_TIMES"
StopTime.delete_all

ap "CREATE STOP_TIMES"

sql = <<-SQL
  COPY public.stop_times (trip_id, arrival_time, departure_time, stop_id, stop_sequence, stop_headsign, pickup_type, drop_off_type, shape_dist_traveled)
  FROM '#{filename}'
  DELIMITER ','
  CSV HEADER QUOTE '"'
SQL

ActiveRecord::Base.connection.execute(sql)

ap "DELETE EXTRA STOP_TIMES"

StopTime.joins('LEFT JOIN "stops" ON "stops"."stop_id" = "stop_times"."stop_id"')
        .where(stops: { stop_id: nil })
        .delete_all


# TRIPS
filename = File.join(__dir__, 'data/trips.csv')
ap "DELETE TRIPS"
Trip.delete_all

ap "CREATE TRIPS"

sql = <<-SQL
  create temporary table t (route_id character varying, service_id integer, trip_id character varying, trip_headsign integer, direction_id integer, block_id character varying, shape_id character varying)
SQL
ActiveRecord::Base.connection.execute(sql)

sql = <<-SQL
  COPY t (route_id, service_id, trip_id, trip_headsign, direction_id, block_id, shape_id)
  FROM '#{filename}'
  DELIMITER ','
  CSV HEADER QUOTE '"'
SQL
ActiveRecord::Base.connection.execute(sql)

sql = <<-SQL
  insert into trips (trip_id, service_id, route_id, trip_headsign, direction_id)
  select trip_id, service_id, route_id, trip_headsign, direction_id
  from t
SQL
ActiveRecord::Base.connection.execute(sql)

sql = <<-SQL
  drop table t
SQL
ActiveRecord::Base.connection.execute(sql)

ap "DELETE EXTRA STOP_TIMES"
Trip.joins('LEFT JOIN "stop_times" ON "stop_times"."trip_id" = "trips"."trip_id" ')
    .where(stop_times: { stop_id: nil })
    .delete_all

# CALENDAR
filename = File.join(__dir__, 'data/calendar.csv')
ap "DELETE CALENDARS"
Calendar.delete_all

ap "CREATE CALENDARS"

sql = <<-SQL
  create temporary table t (service_id integer, monday boolean, tuesday boolean, wednesday boolean, thursday boolean, friday boolean, saturday boolean, sunday boolean, start_date character varying, end_date character varying)
SQL
ActiveRecord::Base.connection.execute(sql)

sql = <<-SQL
  COPY t (service_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday, start_date, end_date)
  FROM '#{filename}'
  DELIMITER ','
  CSV HEADER QUOTE '"'
SQL
ActiveRecord::Base.connection.execute(sql)

sql = <<-SQL
  insert into calendars (service_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday)
  select service_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday
  from t
SQL
ActiveRecord::Base.connection.execute(sql)

sql = <<-SQL
  drop table t
SQL
ActiveRecord::Base.connection.execute(sql)

ap "DELETE EXTRA CALENDARS"

Calendar.where("monday IS FALSE OR tuesday IS FALSE OR wednesday IS FALSE OR thursday IS FALSE OR friday IS FALSE")
        .delete_all
Calendar.joins('LEFT JOIN "trips" ON "trips"."service_id" = "calendars"."service_id" ')
        .where(trips: { trip_id: nil })
        .delete_all


