'use strict'

angular.module 'rentswatchApp'
.config ($stateProvider) ->
  $stateProvider
  .state 'main.quiz',
    url: 'q/'
    templateUrl: 'app/main/quiz/quiz.html'
    controller: 'QuizCtrl as quiz'
    resolve:
      stats: ($http)->
        'ngInject'
        # Simply gets figures from database
        $http.get('/api/docs/all.json').then (rows)-> rows.data
