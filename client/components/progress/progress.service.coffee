angular.module 'rentswatchApp'
  .factory 'Progress', ->
    new class Progress
      constructor: ->
        @body = angular.element 'body'
        @body.append '<div class="progress-container"><div class="progress-container__spinner"><div></div>'
        @progress = angular.element '.progress-container'
      toggle: (toggle)=>
        @state = toggle
        @progress.toggleClass 'progress-container--active', toggle
        @body.toggleClass 'body--progress-active', toggle
      start: => @toggle yes
      complete: => @toggle no
