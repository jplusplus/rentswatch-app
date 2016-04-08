'use strict'

angular
  .module 'rentswatchApp'
    .controller 'QuizCtrl', ($scope, $timeout, $http, $state, stats, steps, settings, hotkeys, Geocoder)->
      'ngInject'
      # Some step may not be available until class values are filled
      RENT_REQUIRED_FROM   = 13
      SPACE_REQUIRED_FROM  = 15
      CENTER_REQUIRED_FROM = 17
      # Return an instance of the class
      new class
        # Current step
        step: 0
        stepCount: steps.length
        rent: 300
        space: 64
        addr: 'Paris, 75011'
        # An image with all ads
        allAds: new Image
        # Default currency
        currency: settings.DEFAULT_CURRENCY
        # List of available currencies
        currencies: settings.CURRENCIES
        # True when the whole app is freezed
        freezed: no
        href: $state.href 'main.quiz', {}, absolute: yes
        constructor: ->
          # Set the Image src to start loading it
          @allAds.src =  '/api/docs/all.png'
          # Avalaible move-in months
          @moveInRange = do @getMoveInRange
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
            if @current().autoplay
              # Create a new timeout
              @autoplay = $timeout @next,  @current().autoplay_delay
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
        stepIndex: (id)=> _.findIndex(steps, id: id)
        # Current step
        current: =>
          # Extend default values with the current step
          angular.extend {
            'autoplay': false,
            'autoplay_delay': 4000,
            'form': false
          }, steps[@step]
        # Comparaison helper
        in: (from, to=steps.length)=>
          # Convert given step's id to index
          from = if isNaN from then @stepIndex(from) else from
          to =   if isNaN to then @stepIndex(to) else to
          # Current step must be in the range
          @step >= from and @step <= to
        is: =>
          # Convert strings arguments to indexes
          indexes = _.map arguments, (a)=>
            a = if isNaN a then @stepIndex(a) else a
          # Current step must be at least one of the given indexes
          _.chain(indexes).values().any( (s)=> @step is s ).value()
        hasForm: => @current().form
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
          avg = @centerStats?.avgPricePerSqm or stats.avgPricePerSqm
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
          avg = @centerStats?.avgPricePerSqm or stats.avgPricePerSqm
          avgPricePerSqm:  avg
          level: @rent / @space
          is: (p)->
            # Part ranges are algorithmically obtained
            if      @level > avg *  2 then 0 is p
            else if @level > avg * .8 then 1 is p
            else 2 is p
        userShare: =>
          for i in [0..2]
            return "quiz.step.share.#{i}" if @userFinalFeedback().is i
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
        getMoveInRange: ->
          months = []
          startYear = (new Date).getFullYear()
          for y in [startYear..(startYear - 4)]
            for m in [11..0]
              dt = new Date y, m, 1, 0, 0, 0
              if dt.getTime() <= Date.now()
                months.push
                  year: y
                  month: m
                  dt: dt
          months
        save: (user)=>
          # Save user with the API
          $http.post('/api/docs/', user)
          # Do not wait and go to the next step
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
