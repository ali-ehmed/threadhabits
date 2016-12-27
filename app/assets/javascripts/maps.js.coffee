class window.GoogleMaps
  constructor: ->
    @markers = []

  @initMap: (mapContainer, opt = {}, callback) =>
    markerOpt = {}
    if opt.marker
      markerOpt = opt.marker

    console.log opt, markerOpt

    location =
      lat: parseFloat(opt.latitude)
      lng: parseFloat(opt.longitude)

    map = new (google.maps.Map)(mapContainer,
      center: location
      zoom: parseInt(opt.zoom) || 20)

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

  holdFormOnAutocomplete: =>
    input = document.getElementsByClassName("google-autocomplete")
    $(input).focus ->
      $(this).closest("form").find("input[type='submit']").prop("disabled", true)
    $(input).blur ->
      $(this).closest("form").find("input[type='submit']").prop("disabled", false)

  # Autocomplete search for google map api
  initAutocomplete: (map, input, callback) =>
    $(input).addClass "google-autocomplete"
    @holdFormOnAutocomplete()

    autocomplete = new (google.maps.places.Autocomplete)(input)
    autocomplete.bindTo 'bounds', map
    infowindow = new (google.maps.InfoWindow)

    marker = new (google.maps.Marker)(
      map: map
      anchorPoint: new (google.maps.Point)(0, -29))
    autocomplete.addListener 'place_changed', ->
      infowindow.close()
      marker.setVisible false
      place = autocomplete.getPlace()

      if !place.geometry
        # User entered the name of a Place that was not suggested and
        # pressed the Enter key, or the Place Details request failed.
        window.alert 'No details available for input: \'' + place.name + '\''
        return
      # If the place has a geometry, then present it on a map.
      if place.geometry.viewport
        map.fitBounds place.geometry.viewport
      else
        map.setCenter place.geometry.location
        map.setZoom 17
        # Why 17? Because it looks good.

      marker.setIcon
        url: place.icon
        size: new (google.maps.Size)(71, 71)
        origin: new (google.maps.Point)(0, 0)
        anchor: new (google.maps.Point)(17, 34)
        scaledSize: new (google.maps.Size)(35, 35)
      marker.setPosition place.geometry.location
      marker.setVisible true

      address = ''

      if place.address_components
        address = [
          place.address_components[0] and place.address_components[0].short_name or ''
          place.address_components[1] and place.address_components[1].short_name or ''
          place.address_components[2] and place.address_components[2].short_name or ''
        ].join(' ')

      infowindow.setContent '<div><strong>' + place.name + '</strong><br>' + address
      infowindow.open map, marker

      if typeof callback == "function"
        callback(place)
      return
    return
