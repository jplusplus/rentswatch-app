'use strict'

angular
  .module 'rentswatchApp'
    .controller 'MainCtrl', ($scope, $timeout, settings)->
      'ngInject'
      # Return an instance of the class
      new class
        # Current step
        step: 0
        stepCount: 7
        # An image with all ads
        allAds: new Image
        constructor: ->
          # Set the Image src to start loading it
          @allAds.src =  '/api/ads/all.png'
          # Start randomized estimation loop
          do @estimationLoop
          # Create axis ticks
          @xticks = ( t * 20 for t in [0..(settings.MAX_LIVING_SPACE/20)-1] )
          @yticks = ( t * 200 for t in [0..(settings.MAX_TOTAL_RENT/200)-1] )
        # Comparaison helper
        in: (from, to=1e9)=> @step >= from and @step <= to
        # Go the next step
        next: => @step++ if @step < @stepCount - 1
        previous: => @step-- if @step > 0
        # Get the part of the user rent's according to the max value
        userRentPart: => @rent/settings.MAX_TOTAL_RENT * 100 + '%'
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
