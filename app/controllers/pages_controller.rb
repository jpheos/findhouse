class PagesController < ApplicationController

  before_action :set_stop_lyon, only: :home

  COLORS = {
   "0"    =>  "000000",
   "1"    =>  "c42525",
   "2"    =>  "c47725",
   "3"    =>  "c4be25",
   "4"    =>  "91c425",
   "more" =>  "5ac425"

  }

  LYON_STOPS = {
    "Part Dieu" => "StopPoint:OCETrain TER-87723197",
    "Jean Macé" => "StopPoint:OCETrain TER-87282624",
    "Perrache" => "StopPoint:OCETrain TER-87722025",
    "Vaise" => "StopPoint:OCETrain TER-87721001"
  }

  def home
    distance_min = 5
    start_time = "07:30"
    end_time  = "08:30"

    stops = Stop.near("Lyon", 80)
    stops = stops.select {|s| s.distance > distance_min}
    @marker = []
    @markers = Gmaps4rails.build_markers(stops) do |stop, marker|

      stats = stop.get_stats_schedule(@stop_lyon, start_time, end_time)
      nb_trains = stats.size

      color = nb_trains > 4 ? "more" : nb_trains.to_s

      backcolor = nb_trains == 0 ? "FFFFFF" : "000000"

      marker.lat stop.stop_lat
      marker.lng stop.stop_lon
      marker.picture({
        "url" => "http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=#{URI::encode(nb_trains.to_s)}|#{COLORS[color]}|#{backcolor}",
        "width" => 60,
        "height" => 60
      })
      marker.infowindow render_to_string(partial: "/stops/stats", locals: { name: stop.stop_name, stats: stats })
    end
  end

  private

  def set_stop_lyon
    if params.has_key?("stop_ids")
      @stop_lyon = params["stop_ids"]
    else
      @stop_lyon = ["StopPoint:OCETrain TER-87722025", "StopPoint:OCETrain TER-87723197", "StopPoint:OCETrain TER-87282624", "StopPoint:OCETrain TER-87721001"]
    end
  end

end
