'use strict'

angular.module 'rentswatchApp', [
  'ngCookies',
  'ngResource',
  'ngSanitize',
  'ngAnimate',
  'ui.router',
  'ui.bootstrap'
]
.config ($stateProvider, $urlRouterProvider, $locationProvider) ->
  $urlRouterProvider
  .otherwise '/'

  $locationProvider.html5Mode true
