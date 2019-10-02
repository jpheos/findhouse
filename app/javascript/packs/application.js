import mapboxgl from 'mapbox-gl'
import 'mapbox-gl/dist/mapbox-gl.css'

// mapboxgl.accessToken = 'pk.eyJ1IjoianBoZW9zIiwiYSI6ImNrMTkxZDVsNjBlY2ozb3RjaGlhYnAxenEifQ.arcnuddTCuTSPB4--bsPhQ'
mapboxgl.accessToken = 'pk.eyJ1IjoianBoZW9zIiwiYSI6ImNrMTkxM2k1MDA1ZWQzZHF3dHRlb3Jzd3QifQ.5DvDuC03teUUOyfkWMbiRQ';

const map = new mapboxgl.Map({
container: 'map',
style: 'mapbox://styles/mapbox/streets-v9'
});
