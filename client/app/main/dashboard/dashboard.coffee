'use strict'

angular.module 'rentswatchApp'
.config ($stateProvider) ->
  $stateProvider
  .state 'main.dashboard',
    url: 'dashboard/:city'
    templateUrl: 'app/main/dashboard/dashboard.html'
    controller: 'DashboardCtrl as dashboard'
    params:
      city:
        value:null
    resolve:
      city: ($stateParams)->
        $stateParams.city
