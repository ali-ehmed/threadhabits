# Application Welcome Coffee
document.addEventListener 'gesturestart', (e) ->
  e.preventDefault()
  
$(document).on "turbolinks:load", ->
  # Hide Flash Message After 5 Seconds
  window.setTimeout (->
    $('.flash-messages').fadeTo(500, 0).slideUp 500, ->
      $(this).hide()
  ), 5000

  $("li.navbar-profile-icon a.dropdown-toggle").click (e) ->
    Turbolinks.visit("/profiles/#{$(this).find('.profile-name').text()}")
    return false

  $("li.navbar-profile-icon").hover (->
    $this = $(this)
    $this.toggleClass 'open'

    $.get "/verify_unread_message", (response) ->
      $this.find("span.notify_message").show() if response.unread == false
    return

  ), ->
    $(this).toggleClass 'open'
    return

# About Us
@AboutUs =
  initialize: ->
    setDefaultActive = true
    path = location.href.split("#")
    path = path[path.length-1]

    if jQuery.inArray("contact", location.href.split("#")) != -1 || jQuery.inArray("toc", location.href.split("#")) != -1 || jQuery.inArray("privacy_policy", location.href.split("#")) != -1
      setDefaultActive = false
      a = $("#about_us .side-affix a[href='##{path}']")
      setTimeout(->
        setDefaultActive = true
        a.closest('li.active').find("span").css("display", "inline-block")
        a.click()
      , 50)

    $('#about_us .side-affix ul li.active span').css("display", "inline-block") if setDefaultActive

    $('#about_us .side-affix').affix({
      offset: {
        top: 0
      }
    })

    $body     = $(document.body)
    $offset = $("#about_us .side-descriptions section").offset().top

    $("body").scrollspy({
      offset: $offset
      target: '#side-about-scrollspy'
    })

    $('#side-about-scrollspy').on 'activate.bs.scrollspy', () ->
      $('#about_us .side-affix ul li').find("span").hide()
      $('#about_us .side-affix ul li.active').find("span").css("display", "inline-block")


    $("#about_us .side-affix a").click ->
      if location.pathname.replace(/^\//, '') == @pathname.replace(/^\//, '') and location.hostname == @hostname
        target = $(@hash)
        target = if target.length then target else $('[name=' + @hash.slice(1) + ']')
        if target.length
          $('html,body').animate { scrollTop: target.offset().top - 80 }, 1000
          return false
      return
