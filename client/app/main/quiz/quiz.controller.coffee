'use strict'

angular
  .module 'rentswatchApp'
    .controller 'QuizCtrl', ($scope, $timeout, $http, stats, settings, hotkeys, Geocoder)->
      'ngInject'
      # Some step may not be available until class values are filled
      RENT_REQUIRED_FROM   = 13
      SPACE_REQUIRED_FROM  = 15
      CENTER_REQUIRED_FROM = 17
      # Some steps trigger an autoplay
      AUTOPLAYED_STEPS = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 16, 19]
      AUTOPLAY_TIMEOUT_DEFAULT = 4000
      AUTOPLAY_TIMEOUT_QUICK = 1000
      # Some steps contain forms
      FORM_STEPS = [12, 13, 15, 17, 19, 20, 21, 22]
      # Steps played rapidely
      QUICK_STEPS = [12, 19]
      # Return an instance of the class
      new class
        # Current step
        step: 0
        stepCount: 23
        # An image with all ads
        allAds: new Image
        # Default currency
        currency: settings.DEFAULT_CURRENCY
        # List of available currencies
        currencies: settings.CURRENCIES
        # True when the whole app is freezed
        freezed: no
        constructor: ->
          # Set the Image src to start loading it
          @allAds.src =  '/api/docs/all.png'
          # Bind keyboard shortcuts
          hotkeys.add
            combo: ['right', 'space']
            description: "Go to the next screen."
            callback: @next
          hotkeys.add
            combo: ['left']
            description: "Go to the previous screen."
            callback: @previous
          # Save the currency's conversion rate
          $scope.$watch 'quiz.currency', (c)=>
            @rate = @currencies[c].CONVERSION_RATE if c? and @currencies[c]?
          # Save the currency's conversion rate
          $scope.$watch 'quiz.step', (step)=>
            # Always cancel current timeout
            $timeout.cancel @autoplay
            # Then if the step must be autoplayed:
            if AUTOPLAYED_STEPS.indexOf(step) > -1
              # Some step are quicker than the other!
              delay = if QUICK_STEPS.indexOf(step) > -1 then AUTOPLAY_TIMEOUT_QUICK else AUTOPLAY_TIMEOUT_DEFAULT
              # Create a new timeout
              @autoplay = $timeout @next, delay
        # Create axis ticks
        xticks: =>
          min  = 20
          max  = settings.MAX_LIVING_SPACE
          tick = 20
          ( Math.round(t * min) for t in [0..(max/tick)-1] )
        yticks: =>
          min  = @rate * 200
          max  = @rate * settings.MAX_TOTAL_RENT
          tick = @currencies[@currency].TICK
          ( Math.round(t * min) for t in [0..(max/tick)-1] )
        # Comparaison helper
        in: (from, to=1e9)=> @step >= from and @step <= to
        is: => _.chain(arguments).values().any( (s)=> @step is s ).value()
        hasForm: => @is.apply @, FORM_STEPS
        hasNext: =>
          # Disabled going further step N without:
          #   * a rend
          return no if @step + 1 > RENT_REQUIRED_FROM   and not @rent?
          #   * a space
          return no if @step + 1 > SPACE_REQUIRED_FROM  and not @space?
          #   * a center's stats
          return no if @step + 1 > CENTER_REQUIRED_FROM and not @centerStats?
          # Disabled step beyond the end
          return no if @freezed or @step >= @stepCount - 1
          # At least, yes!
          return yes
        hasPrevious: => not @freezed and @step > 0
        # Go the next step
        next: (disableOnForm=false)=>
          if do @hasNext and ( not disableOnForm or not @hasForm @step )
            @step++
        previous: => @step-- if do @hasPrevious
        # Get the part of the user rent's according to the max value
        userRentPart: =>
          @rent/(@rate * settings.MAX_TOTAL_RENT) * 100 + '%'
        # Get position of the user point
        userPoint: =>
          bottom: do @userRentPart,
          left: @space/settings.MAX_LIVING_SPACE * 100 + '%'
        # Get the user level compared to other deciles
        userRentLevel: =>
          rent = @rate * @rent
          # Count smaller and higher values
          figures = _.reduce stats.deciles, (res, row)=>
            res.smaller += row.count * (row.to <= rent)
            res.higher += row.count * (row.from > rent)
            res
          , higher: 0, smaller: 0
          # Compute level
          figures.smaller/(figures.smaller + figures.higher)
        userRentFeedback: =>
          # Percentage of flat bellow the user rent
          level = do @userRentLevel
          # Part ranges
          ranges = [ [ 1, .7], [.7, .5], [.5, .3], [.3,  0] ]
          # Return an object
          level: level
          is: (p)-> level <= ranges[p][0] and level > ranges[p][1]
        # There is two ways to get feedback about rent and space:
        #   * using all ads in Europe
        userGlobalFeedback: =>
          avg = stats.avgPricePerSqm
          # How big is the difference between the user's average space by euro
          # and the global average we get from the ads
          avgPricePerSqm: avg
          level: @rent / @space
          times: Math.round (@rent / @space) / avg
          percentage: Math.round( (@rent / @space - avg) / avg * 100)
          is: (p)->
            # Part ranges are algorithmically obtained
            if      @level > avg * 1.5  then 0 is p
            else if @level > avg * 1.05 then 1 is p
            else if @level > avg * 0.95 then 2 is p
            else if @level < avg * 0.85 then 3 is p
            else if @level < avg * 0.95 then 4 is p
            else 5 is p
        #   * using rents around a given center
        userCenterFeedback: =>
          avg = @centerStats.avgPricePerSqm
          # How big is the difference between the user's average space by euro
          # and the global average we get from the ads
          avgPricePerSqm:  avg
          level: @rent / @space
          times: Math.round (@rent / @space) / avg
          percentage: Math.round( (@rent / @space - avg) / avg * 100)
          is: (p)->
            # Part ranges are algorithmically obtained
            if      @level > avg * 2    then 0 is p
            else if @level > avg * 1.05 then 1 is p
            else if @level > avg * 0.95 then 2 is p
            else 3 is p
        userFinalFeedback: =>
          avg = @centerStats.avgPricePerSqm
          avgPricePerSqm:  avg
          level: @rent / @space
          is: (p)->
            # Part ranges are algorithmically obtained
            if      @level > avg *  2 then 0 is p
            else if @level > avg * .8 then 1 is p
            else 2 is p
        # Geocoder the given address and extract stats about it
        geocode: (query)=>
          # Freeze the app
          @freezed = yes
          # Reinitialize address geocoding trackers
          @center = @centerError = @centerStats = null
          # Geocode the addreess
          Geocoder.place(query).then (place)=>
            @center = [ place.lat, place.lon ]
            # Get stat about it
            $http.get '/api/docs/center.json?latlng=' + @center.join(',')
              .then (res)=>
                # Un-freeze the app
                @freezed = no
                # Save center-related stats
                @centerStats = res.data
                # Go to the next point
                do @next
        # Draw the linear regression of the data
        losRegression: (avgPricePerSqm=stats.avgPricePerSqm)=>
          cvswidth = cvsheight = 480*2
          canvas = angular.element("<canvas />").attr width: cvswidth, height: cvsheight
          ctx = canvas[0].getContext '2d'
          # Create scale for y (rent)
          y = d3.scale.linear().domain([0, settings.MAX_TOTAL_RENT]).range [cvsheight, 0]

          startx = cvswidth * 20/settings.MAX_LIVING_SPACE
          starty = cvsheight

          endx = cvswidth
          endy = y(settings.MAX_LIVING_SPACE * avgPricePerSqm)

          # Points color
          ctx.strokeStyle = "#ffd633"

          do ctx.beginPath
          ctx.moveTo startx, starty
          ctx.lineWidth = 2
          ctx.lineTo endx, endy
          do ctx.stroke
          # Returns a base64
          do canvas[0].toDataURL
