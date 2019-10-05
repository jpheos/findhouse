import places from 'places.js'

const initPlaces = () => {
  const cityElement = document.querySelector('#city')
  if (!cityElement)
    return

  var placesAutocomplete = places({
    // appId: "plKLD0BHQSLV",
    // apiKey: "2beec28782dce9d19be43046ba53dd6f",
    container: cityElement
  }).configure({
    type: 'city',
    countries: ['fr'],
    aroundLatLngViaIP: false,
  })

}


export default initPlaces