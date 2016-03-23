'use strict'

angular
  .module 'rentswatchApp'
    .controller 'DashboardCtrl', ($http, $state, settings, dashboard, city, rankings, leafletData)->
      'ngInject'
      # Return an instance of the class
      new class
        constructor: ->
          @city = city
          @showContext = no
          if not @city?
            do @cityLookup
          else
            @map = angular.copy dashboard.map
            @map.center.lat = @city.latitude
            @map.center.lng = @city.longitude
            leafletData.getMap().then @applyGeoJSON
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
        itemBarStyle: (item, set=[], indicator='avgPricePerSqm')=>
          max = _.max set, indicator
          width: 100 * (item[indicator] / max[indicator]) + '%'
          background: if indicator is 'avgPricePerSqm' then @fill(item[indicator]) else undefined
        getRanking: (indicator='avgPricePerSqm')=>
          cityIdx = _.findIndex rankings[indicator], (c)-> c.name is city.name
          _.map rankings[indicator], (c, idx)->
            # Add a rank field
            c.rank = idx + 1
            # The city is visible if:
            #   * it the first of the list
            #   * it is the current city
            #   * it is 2 ranks after and before the current city
            c.visible = idx is 0 or c.name is city.name or Math.abs(cityIdx - idx) <= 2
            c
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
