angular
  .module 'rentswatchApp'
    .constant 'settings',
      # Where should we get the data
      API_URL: 'http://api.rentswatch.com/api/'
      # Plot bounds
      MAX_LIVING_SPACE: 200
      MAX_TOTAL_RENT: 3000
      # Available currencies
      CURRENCIES:
        EUR:
          CONVERSION_RATE: 1
          TICK: 200
        CHF:
          CONVERSION_RATE: 1.0985
          TICK: 220
        # PLN:
        #   CONVERSION_RATE: 4.30715
        #   TICK: 800
      DEFAULT_CURRENCY: 'CHF'
      LOCALE_LOCATION: '//code.angularjs.org/1.2.20/i18n/angular-locale_{{locale}}.js'
      STEP_DEFAULT:
        'autoplay': no
        'autoplay_delay': 4000
        'autoplay_force': no
        'form': no
        "backward": yes
