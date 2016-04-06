'use strict'

angular.module 'rentswatchApp'
.config ($stateProvider) ->
  $stateProvider
  .state 'main',
    url: '/'
    templateUrl: 'app/main/main.html'
    controller: 'MainCtrl as main'
    resolve:
      stats: ($http, settings)->
        'ngInject'
        # Simply gets figures from database
        $http.get(settings.API_URL + 'cities/all', cache: true).then (rows)-> rows.data
