angular.module 'rentswatchApp'
  .service 'rate', (settings, $rootScope)->
    new class Rate
      constructor: ->
        @_currency = settings.DEFAULT_CURRENCY
      get: ()=> settings.CURRENCIES[do @use].CONVERSION_RATE
      use: (currency)=>
        if currency?
          currency = currency.toUpperCase()
          if settings.CURRENCIES[currency]?
            # Does the currency change
            if @_currency isnt currency
              # Update the instance
              @_currency = currency
              # And notify the scope
              $rootScope.$broadcast 'currency:change', currency
        @_currency
