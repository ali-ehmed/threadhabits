class window.GoogleMaps
  constructor: ->
    @markers = []
    
  @initMap: (mapContainer, opt = {}, callback) =>
    markerOpt = {}

    if gon.location != undefined && gon.location.marker != undefined
      markerOpt = gon.location.marker

    console.log opt, markerOpt

    location =
      lat: parseFloat(opt.latitude) || parseFloat(gon.location.latitude) || 0
      lng: parseFloat(opt.longitude) || parseFloat(gon.location.longitude) || 0

    map = new (google.maps.Map)(mapContainer,
      center: location
      zoom: parseInt(opt.zoom) || 17)

    self = new GoogleMaps

    if !jQuery.isEmptyObject(markerOpt)
      self.placeMarkers(map, markerOpt, location)

    google.maps.event.addListener map, 'click', (e) ->
      location.lat = e.latLng.lat()
      location.lng = e.latLng.lng()
      self.setMarkersMap(null) # clear all markers
      console.log e
      self.placeMarkers(map, markerOpt, location)
      if typeof callback == "function"
        callback(e)

    map

  # Places markers and set info window on marker click
  placeMarkers: (map, markerOpt, location) =>
    title = markerOpt.title || ""
    marker = new (google.maps.Marker)(
      position: location
      title: title
      animation: google.maps.Animation.DROP)

    marker.setMap(map)

    infowindow = new (google.maps.InfoWindow)(
      content: '<div><strong>' + title + '</strong>'
    )

    marker.addListener('click', ->
      infowindow.open(map, marker)
    )

    @markers.push(marker)

    marker

  # Set (add/remove) marker from map
  # map = null  -> remove that marker from map
  # map = value -> add the marker on map based on lat/lng
  setMarkersMap: (map) =>
    i = 0
    while i < @markers.length
      @markers[i].setMap(map)
      i++

  getPlaceDetails: (map, place_id, callback) =>
    result = {}
    service = new google.maps.places.PlacesService(map);
    service.getDetails { placeId: place_id }, (place, status) ->
      if status == google.maps.places.PlacesServiceStatus.OK
        callback place
