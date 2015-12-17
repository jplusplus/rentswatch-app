'use strict'

angular.module 'rentswatchApp'
.config ($stateProvider) ->
  $stateProvider
  .state 'main',
    url: '/'
    templateUrl: 'app/main/main.html'
    controller: 'MainCtrl as main'
    resolve:
      decades: ($http)->
        'ngInject';
        # Simply gets decades figures from database
        $http.get('/api/docs/decades.json').then (rows)-> rows.data
