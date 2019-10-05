class CitiesController < ApplicationController
  before_action :start_time
  before_action :end_time
  before_action :range

  DEFAULT_RANGE = 90

  COLORS = {
   "0"    =>  "000000",
   "1"    =>  "c42525",
   "2"    =>  "c47725",
   "3"    =>  "c4be25",
   "4"    =>  "91c425",
   "more" =>  "5ac425"
  }

  def show
    @stops = Stop.near(city, 4)
  end

  def search
    redirect_to city_path(params[:city])
  end

  def data
    stops = Stop.near(city, range).where.not(stop_id: stop_ids)
    all_stats = Stop.get_many_stats_schedule(stops.map(&:stop_id), stop_ids, start_time, end_time)

    ret = stops.to_a.map do |stop|
      stats = all_stats[stop.stop_id] || []
      nb_trains = stats.size
      color = nb_trains > 4 ? "more" : nb_trains.to_s
      backcolor = nb_trains.zero? ? "FFFFFF" : "000000"

      stop.attributes.merge(
        trips_count: stats.size,
        stats: stats,
        icon_url: "http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=#{URI::encode(nb_trains.to_s)}|#{COLORS[color]}|#{backcolor}",
        html: render_to_string(partial: "/stops/stats.html", locals: { name: stop.stop_name, stats: stats })
      )
    end
    render json: ret
  end

  private

  def city
    @city ||= params[:id]
  end

  def stop_ids
    params[:stop_ids]
  end

  def range
    @range ||= (params[:range] || DEFAULT_RANGE).to_i
  end

  def start_time
    @start_time ||= (params[:start_time] || "07:30")
  end

  def end_time
    @end_time ||= (params[:end_time] || "08:30")
  end
end
