'use strict'

angular
  .module 'rentswatchApp'
    .controller 'DashboardCtrl', ($http, $state, $scope, $timeout, settings, dashboard, all, city, rankings, leafletData, rate)->
      'ngInject'
      # Return an instance of the class
      new class
        # All available cities (will be overrided by cityLookup)
        cities: all
        # Cuurent city
        city: city
        # Show or no the context menu
        showContext: no
        # Current currency
        currency: rate.use()
        constructor: ->
          # Current currency might change
          $scope.$on 'currency:change', (ev, currency)=> @currency = currency
          # Is a city given?
          if @city?
            if @city.neighborhoods?
              @city.neighborhoods = _.filter @city.neighborhoods, (n)-> n.avgPricePerSqm?
              @map = angular.copy dashboard.map
              @map.center.lat = @city.latitude
              @map.center.lng = @city.longitude
              leafletData.getMap().then @applyGeoJSON
            else
              $state.go 'main.dashboard', city: null
          # Deactivated until we use the autocomplete
          # else
            # do @cityLookup
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
          if city?
            $state.go 'main.dashboard', city: city.slug
          @city
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
        showCurrentPricePerSqm: =>!! @_showCurrent
        current: (current)=>
          if current?
            @_current = current
            @_showCurrent = yes
            # Clear existing timeout
            $timeout.cancel @currentTimeout
            @currentTimeout = $timeout =>
              # Activate price displaying
              @_showCurrent = no
            , 4000
          @_current
        applyGeoJSON: (map)=>
          # Create the tiles layer
          @geojsonTileLayer = new L.TileLayer.GeoJSON dashboard.geojson.url, {
            clipTiles: yes
            unique: (feature)-> feature.id;
          }, {
            style: dashboard.geojson.style,
            onEachFeature: @onEachFeature
          }
          # Bind it to the map
          map.addLayer @geojsonTileLayer
        onEachFeature: (feature, layer)=>
          if feature.properties?
            layer.setStyle fillColor: @fill(feature.properties.price_per_sqm)
            layer.on 'mouseover click', @bindFeatureClick(feature.properties)
        bindFeatureClick: (properties)=>
          (event)=>
            # For an unkown reason the map triggers 2 events.
            # The one that do not contain a layer attribute is the right one.
            unless event.layer?
              $scope.$apply =>
                # Register the last overed tile's price
                @current properties
