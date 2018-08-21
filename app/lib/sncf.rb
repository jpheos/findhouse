class Sncf
  def initialize(api_key)
    @api_key = api_key
  end

  def find_stations(city, distance)
    params = {
      dataset: "referentiel-gares-voyageurs",
      rows: 200,
      # sort: "intitule_gare",
      # facet: "agence_gare",
      # facet: "region_sncf",
      # facet: "unite_gare",
      # facet: "departement",
      # facet: "region",
      # facet: "segment_drg",
      "geofilter.distance": "#{city[:lat]},#{city[:lng]},#{distance * 1000}"
    }

    query = URI.encode_www_form(params)

    url       = "https://data.sncf.com/api/records/1.0/search/?#{query}"
    ap url
    JSON.parse(open(url).read)["records"]
  end

  def find_stations_interval(city, distance_min, distance_max)
    stations_min = find_stations(city, distance_min)
    stations_max = find_stations(city, distance_max)
    stations_min_id = stations_min.map{|s| s["recordid"]}
    stations_max.reject{|s| stations_min_id.include?(s["recordid"]) }
  end

end
