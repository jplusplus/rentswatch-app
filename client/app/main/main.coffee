'use strict'

angular.module 'rentswatchApp'
.config ($stateProvider) ->
  $stateProvider
  .state 'main',
    url: '/'
    templateUrl: 'app/main/main.html'
    controller: 'MainCtrl as main'
    resolve:
      stats: ($http)->
        'ngInject';
        # Simply gets figures from database
        $http.get('/api/docs/all.json').then (rows)-> rows.data
