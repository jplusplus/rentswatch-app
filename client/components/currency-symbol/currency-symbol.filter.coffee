angular.module 'rentswatchApp'
  .filter 'currencySymbol', (settings)->
    (currency)->
      # Take a default currency
      symbol = currency = do rate.use unless currency?
      # Does the given currency exist
      if settings.CURRENCIES[currency]?
        # Gets its symbol
        symbol = settings.CURRENCIES[currency].SYMBOL
      # Simply does the product
      symbol
