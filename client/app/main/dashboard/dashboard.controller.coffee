'use strict'

angular
  .module 'rentswatchApp'
    .controller 'DashboardCtrl', ($http, $state, settings, city)->
      'ngInject'
      # Return an instance of the class
      new class
        constructor: ->
          @city = city
          do @cityLookup
        cityLookup: (q)=>
          return @cities = [] unless q? and q.length > 1
          # Build lookup params
          config = params:
            q: q, has_neighborhoods: 1
          # Or returns a promise
          $http.get(settings.API_URL + 'cities/search/', config).then (r)=>
            # Update the cities list
            @cities = r.data
        selectCity: (city)->
          $state.go 'main.dashboard', city: city.slug
