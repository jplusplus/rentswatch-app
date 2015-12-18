'use strict'

angular
  .module 'rentswatchApp'
    .controller 'MainCtrl', ($scope, $timeout, stats, settings, hotkeys)->
      'ngInject'
      # Return an instance of the class
      new class
        # Current step
        step: 0
        stepCount: 9
        # rent: 800
        # space: 35
        # An image with all ads
        allAds: new Image
        constructor: ->
          # Set the Image src to start loading it
          @allAds.src =  '/api/docs/all.png'
          # Start randomized estimation loop
          do @estimationLoop
          # Create axis ticks
          @xticks = ( t * 20 for t in [0..(settings.MAX_LIVING_SPACE/20)-1] )
          @yticks = ( t * 200 for t in [0..(settings.MAX_TOTAL_RENT/200)-1] )
          # Bind keyboard shortcuts
          hotkeys.add
            combo: ['right', 'space']
            description: "Go to the next screen."
            callback: @next
          hotkeys.add
            combo: ['left']
            description: "Go to the previous screen."
            callback: @previous
        # Comparaison helper
        in: (from, to=1e9)=> @step >= from and @step <= to
        is: (s)=> @step is s
        # Go the next step
        next: =>
          # Disabled going further step 0 without rent
          return if @step + 1 > 0 and not @rent
          # Disabled step beyond the end
          return if @step + 1 > 6 and not @space
          # Disabled step beyond the end
          return if @step >= @stepCount - 1
          # We can go further
          @step++
        previous: => @step-- if @step > 0
        # Get the part of the user rent's according to the max value
        userRentPart: => @rent/settings.MAX_TOTAL_RENT * 100 + '%'
        # Get position of the user point
        userPoint: =>
          bottom: do @userRentPart,
          left: @space/settings.MAX_LIVING_SPACE * 100 + '%'
        # Get the user level compared to other decades
        userRentLevel: =>
          # Count smaller and higher values
          figures = _.reduce stats.decades, (res, row)=>
            res.smaller += row.count * (row.to <= @rent)
            res.higher += row.count * (row.from > @rent)
            res
          , higher: 0, smaller: 0
          # Compute level
          figures.level = figures.smaller/( figures.smaller + figures.higher)
          # Returns the 3 figures
          figures
        # There is approximatively 1 ad scraped by second so
        # we should be able to estimated approximatively the number
        # of ad currently in the database.
        estimateAds: -> settings.TOTAL_ADS + ~~(Date.now()/1e3 - settings.LAST_SNAPSHOT)
        # This will trigger an infinite (and irregular loop of estimation)
        estimationLoop: =>
          # This value will be updated regulary
          @totalAds = do @estimateAds
          # Use a random timeout to estimate the number of ad
          $timeout @estimationLoop, Math.random() * 1000
