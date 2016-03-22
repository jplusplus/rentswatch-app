angular.module('rentswatchApp')
  .directive('fixFocus', ['$animate', function($animate){
    return {
       restrict: 'A',
       require: 'uiSelect',
       link: function(scope, elt, attrs, $select){
          $animate.on('removeClass', $select.searchInput[0], function(input) {
             input.focus();
          });

          scope.$on('$destroy', function(){
             $animate.off('removeClass', $select.searchInput[0]);
          });
       }
    };
  }])
