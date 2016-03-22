'use strict'

angular
  .module 'rentswatchApp'
    .controller 'DashboardCtrl', (city)->
      'ngInject'
      # Return an instance of the class
      new class
        constructor: ->
          @city = city
