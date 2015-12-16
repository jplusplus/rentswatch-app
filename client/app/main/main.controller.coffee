'use strict'

angular
  .module 'rentswatchApp'
    .controller 'MainCtrl', ($scope, $timeout, settings)->
      'ngInject'
      # Return an instance of the class
      new class
        # Current step
        step: 3
        rent: 800
        # An image with all ads
        allAds: new Image
        constructor: ->
          # When the image is loaded, we calculate the image ratio (to draw axis)
          @allAds.onload = @setAllAdsRatio
          # Set the Image src to start loading it
          @allAds.src =  '/api/ads/all.png'
          # Start randomized estimation loop
          do @estimationLoop
          # Create axis ticks
          @xticks = ( t * 20 for t in [0..(settings.MAX_LIVING_SPACE/20)-1] )
          @yticks = ( t * 200 for t in [0..(settings.MAX_TOTAL_RENT/200)-1] )
        # Look the allAds image to calculate the image ratio
        setAllAdsRatio: =>
          # Image loading event is of angular digest
          $scope.$apply => @allAdsRatio = @allAds.height/@allAds.width
        # Comparaison helper
        in: (from, to=1e9)=> @step >= from and @step <= to
        # Go the next step
        next: => @step++
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
