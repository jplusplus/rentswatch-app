angular.module('rentswatchApp').directive("screenHeight", ["$window", function($window) {
    return function(scope, element, attrs) {
     	var ev = "resize.screenHeight-" + _.uniqueId();
     	var resize = function() {
	        if (!isNaN(attrs.screenHeight)) {
	        	element.css("min-height", Math.max(attrs.screenHeight,  $window.innerHeight) );
	        } else {
	          element.css("min-height", $window.innerHeight);
          }
      	};

      	resize();
      	angular.element($window).bind(ev, resize);

      	scope.$on('$destroy', function() {
        	angular.element($window).unbind(ev);
      	});
    };
  }
]);
