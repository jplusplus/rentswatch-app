angular
  .module 'rentswatchApp'
    .constant 'dashboard',
      # fillcolors: ['#944343', '#d35f5f','#FFA176']
      # fillcolors: ['#FFEDA0', '#FED976','#FEB24C','#FD8D3C', '#FC4E2A','#E31A1C','#BD0026', '#800026']
      fillcolors: ['#edf8fb', '#bfd3e6', '#9ebcda', '#8c96c6', '#8c6bb1', '#88419d', '#6e016b', '#800026']
      geojson:
        url: 'http://api.rentswatch.com/api/tiles/{z}/{x}/{y}'
        style:
          clickable: false
          color: "#211F30"
          fillColor: "#211F30"
          weight: 1.0,
          opacity: 0,
          fillOpacity: .7
      map:
        center:
          zoom: 11
        defaults:
          maxZoom: 12
          minZoom: 4
          zoomControl: yes
          scrollWheelZoom: no
        tiles:
          name: 'CartoDB.Positron'
          type: 'sxyz'
          url: "http://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png",
          options:
            attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> &copy; <a href="http://cartodb.com/attributions">CartoDB</a>'
            subdomains: 'abcd'
            minZoom: 0
            maxZoom: 19
            continuousWorld: no
            noWrap: yes
