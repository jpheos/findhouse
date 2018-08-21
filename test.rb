ap "je suis dnas le test"

stop_lyon = ["StopPoint:OCETrain TER-87722025", "StopPoint:OCETrain TER-87723197", "StopPoint:OCETrain TER-87282624", "StopPoint:OCETrain TER-87721001"]

# ap Stop.where(stop_id: stop_lyon).map(&:stop_name)


# stop_area_lyon = Stop.near("lyon", 60)



# saint_germain = stop_area_lyon.where("stop_name ILIKE '%germain%'").first


# stoptime_saint_germain = StopTime.where(stop_id: saint_germain.stop_id)

# stsg = stoptime_saint_germain.order(:departure_time).where("extract(hour from stop_times.departure_time) BETWEEN 7 and 8").map {|st| st.departure_time.strftime("%H:%M")}.uniq



# ap stgs


id = "StopPoint:OCETrain TER-87721282"


ap Stop.find(id).get_stats_schedule(stop_lyon, "07:00", "09:00")



# "gare_start" => "Gare de St-Germain-au-Mont-d'Or",
#         "start_time" => "07:54:00",
#           "gare_end" => "Gare de Lyon-Jean-Macé",
#           "end_time" => "08:23:00",
#            "trip_id" => "OCESN887109F0200348841",
#         "service_id" => 2112,
#             "monday"

