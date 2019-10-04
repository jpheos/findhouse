class PagesController < ApplicationController

  COLORS = {
   "0"    =>  "000000",
   "1"    =>  "c42525",
   "2"    =>  "c47725",
   "3"    =>  "c4be25",
   "4"    =>  "91c425",
   "more" =>  "5ac425"
  }

  def city
    ap "je sui sla"
  end

  def results


    stops = Stop.near(params[:city], 80).where.not(stop_id: stop_ids)

    ap stops.class


    all_stats = Stop.get_many_stats_schedule(stops.map(&:stop_id), stop_ids, start_time, end_time)

    @markers = Gmaps4rails.build_markers(stops) do |stop, marker|

      stats = all_stats[stop.stop_id] || []
      nb_trains = stats.size

      color = nb_trains > 4 ? "more" : nb_trains.to_s

      backcolor = nb_trains == 0 ? "FFFFFF" : "000000"

      marker.lat stop.stop_lat
      marker.lng stop.stop_lon
      marker.picture({
        "url" => "http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=#{URI::encode(nb_trains.to_s)}|#{COLORS[color]}|#{backcolor}",
        "width" => 21,
        "height" => 34
      })
      marker.infowindow render_to_string(partial: "/stops/stats", locals: { name: stop.stop_name, stats: stats })
    end
  end

  def select_stations
    @stops = Stop.near(params[:city], 4)
    ap @stops
  end

  def home

  end

  private

  def start_time
    @start_time ||= (params[:time] && !params[:time][:start].blank?) ? params[:time][:start] : "07:30"
  end

  def end_time
    @end_time ||= (params[:time] && !params[:time][:end].blank?) ? params[:time][:end] : "08:30"
  end

  def stop_ids
    @stop_ids ||= params[:stop_ids]
  end

end
