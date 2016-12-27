class window.MainSubject
  @observers: []
  @subscribe: (observer) ->
    @observers.push(observer)

  @unsubscribe: (fn) ->
    @observers = @observers.filter((item) ->
      if item != fn
        return item
      return
    )

  @publish: (message, key, value) ->
    @observers.forEach (item) ->
      if Array.isArray(message)
        message.forEach (msg) ->
          item[msg](key, value)
      else
        item[message](key, value)

class Settings
  @current_location: {}

  constructor: ->
    @inputs =
      location: document.getElementById("location_input")
      latitude: document.getElementById("latitude_input")
      longitude: document.getElementById("longitude_input")
      place_id: document.getElementById("place_id_input")

  initializeLocation: () =>
    if navigator.geolocation
      navigator.geolocation.getCurrentPosition(@showPosition)
    else
      alert 'Geolocation is not supported by this browser.'
    return

  showPosition: (position) =>
    Settings.current_location.latitude = position.coords.latitude
    Settings.current_location.longitude = position.coords.longitude
    console.log 'Latitude: ' + position.coords.latitude + '<br>Longitude: ' + position.coords.longitude
    return

  updateCurrentLocation: (key, value) =>
    Settings.current_location[key] = value

  updateLocationInputs: (key, value) =>
    @inputs[key].value = value

class Profiles extends Settings
  setMap: ->
    that = this
    container = document.getElementById("google-maps")
    googleMap = new GoogleMaps

    MainSubject.subscribe(that)

    MainSubject.publish(["updateLocationInputs"], "latitude", Settings.current_location.latitude)
    MainSubject.publish(["updateLocationInputs"], "longitude", Settings.current_location.latitude)

    map = GoogleMaps.initMap container, Settings.current_location, (marker) ->
      MainSubject.publish(["updateCurrentLocation", "updateLocationInputs"], "latitude", marker.latLng.lat())
      MainSubject.publish(["updateCurrentLocation", "updateLocationInputs"], "longitude", marker.latLng.lng())

      if marker.placeId
        googleMap.getPlaceDetails map, marker.placeId, (place) ->
          MainSubject.publish(["updateCurrentLocation", "updateLocationInputs"], "location", place.name)
          MainSubject.publish(["updateCurrentLocation", "updateLocationInputs"], "place_id", marker.placeId)

$(document).on "turbolinks:load", ->
  profiles = new Profiles
  profiles.initializeLocation()

  setTimeout(->
    profiles.setMap()
  , 1000)
