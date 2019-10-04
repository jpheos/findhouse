const { environment } = require('@rails/webpacker')

environment.loaders.delete('nodeModules'); // https://stackoverflow.com/questions/57628793/react-map-gl-uncaught-referenceerror-typeof-is-not-defined

module.exports = environment
