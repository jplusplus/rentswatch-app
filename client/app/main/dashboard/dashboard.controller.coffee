'use strict'

angular
  .module 'rentswatchApp'
    .controller 'DashboardCtrl', ($http, $state, settings, dashboard, city, leafletData)->
      'ngInject'
      # Return an instance of the class
      new class
        constructor: ->
          @city = city
          if not @city?
            do @cityLookup
          else
            @map = angular.copy dashboard.map
            @map.center.lat = @city.latitude
            @map.center.lng = @city.longitude
            leafletData.getMap().then @applyGeoJSON
        fill: (v)=>
          unless @scale?
            min = @city.avgPricePerSqm - 15
            max = @city.avgPricePerSqm + 10
            @scale = chroma.scale(dashboard.fillcolors).domain([min, max], 7, 'quantiles')
          # Get color for the given value
          do @scale(v).hex
        applyGeoJSON: (map)=>
          # Create the tiles layer
          @geojsonTileLayer = new L.TileLayer.GeoJSON dashboard.geojson.url, {
            clipTiles: yes
            unique: (feature)-> feature.id;
          }, { style: dashboard.geojson.style, onEachFeature: @setFeatureStyle }
          # Bind it to the map
          map.addLayer @geojsonTileLayer
        setFeatureStyle: (feature, layer)=>
          layer.setStyle fillColor: @fill(feature.properties.price_per_sqm)
        cityLookup: (q)=>
          return @cities = [] unless q? and q.length > 1
          # Build lookup params
          config = params:
            q: q, has_neighborhoods: 0
          # Or returns a promise
          $http.get(settings.API_URL + 'cities/search/', config).then (r)=>
            # Update the cities list
            @cities = r.data
        selectCity: (city)->
          $state.go 'main.dashboard', city: city.slug
