'use strict'

angular.module 'rentswatchApp'
.config ($stateProvider) ->
  $stateProvider
  .state 'main',
    url: '/?lang&currency'
    params:
      lang:
        value: null
      currency:
        value: null
    templateUrl: 'app/main/main.html'
    controller: 'MainCtrl as main'
    resolve:
      use: ($stateParams, $state, $translate, rate)->
        if $stateParams.lang?
          $translate.use $stateParams.lang.toLowerCase()
        if $stateParams.currency?
          rate.use $stateParams.currency.toUpperCase()
      stats: ($http, settings)->
        'ngInject'
        # Simply gets figures from database
        $http.get(settings.API_URL + 'cities/all', cache: true).then (rows)-> rows.data
