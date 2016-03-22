'use strict'

angular.module 'rentswatchApp', [
  'ngCookies',
  'ngResource',
  'ngSanitize',
  'ngAnimate',
  'ui.router',
  'ui.bootstrap',
  'ui.select',
  'cfp.hotkeys',
  'leaflet-directive'
]
.config ($stateProvider, $urlRouterProvider, $locationProvider) ->
  $urlRouterProvider.otherwise '/'
