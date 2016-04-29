'use strict'

angular
  .module 'rentswatchApp'
    .controller 'MainCtrl', ($timeout, $translate, $sce, stats)->
      'ngInject'
      # Return an instance of the class
      new class
        constructor: ->
          @use = $translate.use
          # Start estimation loop
          do @estimationLoop
        videoSrc: ->
          $sce.trustAsResourceUrl [
            "//www.youtube.com/embed/_a7g69kXn_o?cc_load_policy=1&amp;hl=",
            $translate.use(),
            "&amp;cc_lang_pref=",
            $translate.use()
          ].join('')
        # There is approximatively 1 ad scraped by second so
        # we should be able to estimated approximatively the number
        # of ad currently in the database.
        estimateAds: ->
          stats.total + ~~(stats.pace * (Date.now()/1e3 - stats.lastSnapshot))
        # This will trigger an infinite (and irregular loop of estimation)
        estimationLoop: =>
          # This value will be updated regulary
          @totalAds = do @estimateAds
          # Use a random timeout to estimate the number of ad
          $timeout @estimationLoop, Math.random() * 1000
