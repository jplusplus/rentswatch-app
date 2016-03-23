angular.module 'rentswatchApp'
  .config ($translateProvider)->
    'ngInject'
    $translateProvider
      .useStaticFilesLoader
        prefix: 'assets/locales/',
        suffix: '.json'
      .registerAvailableLanguageKeys ['en'],
        'en_US': 'en',
        'en_UK': 'en',
        'en-US': 'en',
        'en-UK': 'en',
      .determinePreferredLanguage ->
        lang = navigator.language or navigator.userLanguage
        avalaibleKeys = [
          'en_US', 'en_UK', 'en-UK', 'en-US', 'en'
        ]
        if avalaibleKeys.indexOf(lang) is -1 then 'en' else lang
      .fallbackLanguage ['en']
      .useCookieStorage()
      .useSanitizeValueStrategy null
