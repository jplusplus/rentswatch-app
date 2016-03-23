'use strict'

angular
  .module 'rentswatchApp'
    .controller 'NavbarCtrl', ($scope, $translate)->
      $scope.isCollapsed = true
      $scope.use = $translate.use
