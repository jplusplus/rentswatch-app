angular.module 'rentswatchApp'
  .service 'rate', (settings)->
    new class Rate
      constructor: ->
        @_currency = settings.DEFAULT_CURRENCY
      use: (currency)=>
        if currency?
          currency = currency.toUpperCase()
          if settings.CURRENCIES[currency]?
            @_currency = currency
        @_currency
