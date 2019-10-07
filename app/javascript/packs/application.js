import 'mapbox-gl/dist/mapbox-gl.css'
import mapboxgl from 'mapbox-gl'
import initPlaces from '../init_places'

initPlaces()

const mapElement    = document.querySelector('#map')
const form          = document.querySelector('#form')
const markers       = []
let   alreadyFitMap = false
let   map


const fitMapToMarkers = (stops) => {
  const bounds = new mapboxgl.LngLatBounds()
  stops.forEach(stop => bounds.extend([ stop.stop_lon, stop.stop_lat ]))
  map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 })
  alreadyFitMap = true
}

const removeAllMarkers = () => {
  let m
  while (m = markers.pop()) {
    m.remove()
  }
}

const addMarkerToMap = (stop) => {
  const popup = new mapboxgl.Popup().setHTML(stop.html).setMaxWidth("800px")

  const element = document.createElement('div');
  element.className = 'marker';
  element.style.backgroundImage = `url('${stop.icon_url}')`;
  element.style.backgroundSize = 'contain';
  console.log(stop.trips_count)
  if (stop.trips_count == 0) {
    element.style.width = '9px';
    element.style.height = '15px';
  } else {
    element.style.width = '18px';
    element.style.height = '29px';
  }

  const marker = new mapboxgl.Marker(element)
  .setLngLat([stop.stop_lon, stop.stop_lat])
  .setPopup(popup)
  .addTo(map);

  markers.push(marker)
}

const updateMarkers = (stops) => {
  removeAllMarkers()
  stops.forEach(addMarkerToMap)
  if (!alreadyFitMap)
    fitMapToMarkers(stops)
}

const synchroServer = () => {
  const city = mapElement.dataset.city
  const queryString = new URLSearchParams(new FormData(form)).toString()


  fetch(`${city}/data.json?${queryString}`)
  .then(function(response) {
    return response.json();
  })
  .then(function(json) {
    updateMarkers(json)
  });

}

const initMap = () => {
  if (!mapElement)
    return

  mapboxgl.accessToken = mapElement.dataset.apiKey

  map = new mapboxgl.Map({
    container: 'map',
    style: 'mapbox://styles/jpheos/ck1apy8z419lp1cqhxe1giia8'
  })


  form.querySelectorAll('input').forEach((input) => {
    input.addEventListener('change', (e) => {
      synchroServer()
    })
  })

  synchroServer()
}


initMap()


