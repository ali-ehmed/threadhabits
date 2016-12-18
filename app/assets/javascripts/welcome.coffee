# Application Welcome Coffee
$(document).on "turbolinks:load", ->
  # Hide Flash Message After 5 Seconds
  window.setTimeout (->
    $('.flash-messages').fadeTo(500, 0).slideUp 500, ->
      $(this).hide()
  ), 5000

  $("li.navbar-profile-icon .dropdown-menu").click (e) ->
    unless $(e.target).is("a") or $(e.target).is("i")
      return false
      
  $("li.navbar-profile-icon a.dropdown-toggle").click (e) ->
    return false

  $("li.navbar-profile-icon").hover (->
    # $('.dropdown-menu', this).stop( true, true ).fadeIn("fast");
    $(this).toggleClass 'open'
    return
  ), ->
    # $('.dropdown-menu', this).stop( true, true ).fadeOut("fast");
    $(this).toggleClass 'open'
    return
