# Application Welcome Coffee
$(document).on "turbolinks:load", ->
  # Hide Flash Message After 5 Seconds
  window.setTimeout (->
    $('.flash-messages').fadeTo(500, 0).slideUp 500, ->
      $(this).hide()
  ), 5000

  $("li.navbar-profile-icon a.dropdown-toggle").click (e) ->
    Turbolinks.visit("/#{$(this).find('.profile-name').text()}")
    return false

  $("li.navbar-profile-icon").hover (->
    $this = $(this)
    $this.toggleClass 'open'
    $.get "	/home/verify_unread_message", (response) ->
      $this.find("span.notify_message").show() if response.unread == false
    return
  ), ->
    $(this).toggleClass 'open'
    return
