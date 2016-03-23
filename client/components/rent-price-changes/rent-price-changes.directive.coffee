angular.module 'rentswatchApp'
  .directive 'rentPriceChanges', (dashboard, $filter)->
    'ngInject'
    restrict: 'E'
    scope:
      months: "="
    link: (scope, element, attr)->
      new class RentPriceChanges
        TRANSITION_DURATION: 600
        DEFAULT_CONFIG: c3.chart.internal.fn.getDefaultConfig()
        getXValues: => _.map(scope.months, 'month')
        generateColumns: =>
          series = [ ['x'].concat do @getXValues ]
          series.push( ['changes'].concat _.map(scope.months, 'avgPricePerSqm') )
          series
        generateXAxis: (columns)=>
          # Return a configuration objects
          type: 'categories'
          categories: do @getXValues
          tick:
            outer: false
            centered: yes
            culling:
              max: 5
            multiline: no
        generateYAxis: (columns)=>
          # Return a configuration objects
          tick:
            count: 5
            format: (d)-> $filter('number')(d, 1) + '€/m²'
          padding:
            bottom: 20
        generateColors: (columns)=>
          changes: dashboard.fillcolors[0]
        generateChart: =>
          columns = do @generateColumns
          window.c = @chart = c3.generate
            # Enhance the chart with d3
            # onrendered: @enhanceChart
            bindto: element[0]
            interaction:
              enabled: yes
            padding:
              right: 20
              top: 20
            legend:
              show: no
            tooltip:
              show: no
            point:
              show: no
            line:
              connectNull: yes
            transition:
              duration: @TRANSITION_DURATION
            axis:
              x: @generateXAxis columns
              y: @generateYAxis columns
            grid:
              y:
                show: yes
            data:
              x: 'x'
              type: 'line'
              columns: columns
              colors: @generateColors columns
        constructor: ->
          # Generate the chart
          do @generateChart
