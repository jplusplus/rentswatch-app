'use strict'

angular
  .module 'rentswatchApp'
    .controller 'NavbarCtrl', ($scope, $translate, rate, settings)->
      $scope.isCollapsed = true
      $scope.currencies = settings.CURRENCIES
      # Currency helper
      $scope.currency =
        is: (c)-> rate.use() is c
        use: rate.use
      # Language helper
      $scope.language =
        is: (t)-> $translate.use() is t
        use: $translate.use
