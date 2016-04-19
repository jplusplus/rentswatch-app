'use strict'

angular.module 'rentswatchApp'
.config ($stateProvider) ->
  $stateProvider
  .state 'main.dashboard',
    url: ':city'
    templateUrl: 'app/main/dashboard/dashboard.html'
    controller: 'DashboardCtrl as dashboard'
    params:
      city:
        value:null
    resolve:
      all: ($http, settings)->
        $http.get(settings.API_URL + 'cities/?has_neighborhoods=1', { cache: true}).then (r)-> r.data
      rankings: ($http, $q, settings)->
        # Get 2 rankings
        $q.all([
          $http.get(settings.API_URL + 'cities/ranking?indicator=avgPricePerSqm', { cache: true})
          $http.get(settings.API_URL + 'cities/ranking?indicator=inequalityIndex', { cache: true})
        ]).then (results)->
          # Create an object with the result
          avgPricePerSqm: _.map results[0].data, (c)-> name: c[0], avgPricePerSqm: c[1]
          inequalityIndex: _.map results[1].data, (c)-> name: c[0], inequalityIndex: c[1]
      city: ($stateParams, $http, settings)->
        return null unless $stateParams.city?
        # Get the city from the api
        $http.get(settings.API_URL + 'cities/' + $stateParams.city, { cache: true }).then (r)-> r.data
