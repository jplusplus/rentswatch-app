angular.module 'rentswatchApp'
  .filter 'rate', (settings, rate)->
    (amount, currency)->
      # Take a default currency
      currency = do rate.use unless currency?
      # Does the given currency exist
      if settings.CURRENCIES[currency]?
        # Gets its exchange rate
        conversionRate = settings.CURRENCIES[currency].CONVERSION_RATE
      else
        # Use a default exchange to 1 (no convertion)
        conversionRate = 1
      # Simply does the product
      amount * conversionRate
