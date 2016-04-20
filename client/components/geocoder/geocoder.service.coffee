'use strict'

angular
  .module 'rentswatchApp'
    .service 'Geocoder', ($q, $http)->
      class Geocoder
        @place: (query)->
          deferred = do $q.defer
          # If no address is provided
          if not query?
            deferred.reject('No value')
          else
            # Use OSM API to geocode the given address
            url  = "//nominatim.openstreetmap.org/search?"
            url += "format=json&"
            url += "limit=1&"
            url += "osm_type=N&"
            url += "addressdetails=1&"
            url += "&q=" + query + "&json_callback=JSON_CALLBACK"
            # OSM API uses JSONP to return result
            $http.jsonp(url).then (res)->
              if res.data and res.data.length
                deferred.resolve res.data[0]
              else
                deferred.reject 'No result'
          # Return a promise
          return deferred.promise;
