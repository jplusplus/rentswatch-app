'use strict'

angular.module 'rentswatchApp'
.config ($stateProvider) ->
  $stateProvider
  .state 'main.dashboard',
    url: 'c/:city'
    templateUrl: 'app/main/dashboard/dashboard.html'
    controller: 'DashboardCtrl as dashboard'
    params:
      city:
        value:null
    resolve:
      city: ($stateParams, $http, settings)->
        return null unless $stateParams.city?
        # Get the city from the api
        $http.get(settings.API_URL + 'cities/' + $stateParams.city).then (r)-> r.data
