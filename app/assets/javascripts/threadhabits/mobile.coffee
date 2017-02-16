@Mobile =
  disabledEventPropagation: (event) ->
    if event.stopPropagation
      event.stopPropagation()
    else if window.event
      window.event.cancelBubble = true

  sideMenu: ->
    that = this
    # opening side menu
    $(".navbar-toggle.collapsed").click (e) ->
      that.disabledEventPropagation(e)
      $("#nav-menu-bar").css "left", "0px"
      setTimeout(->
        $(".main-container").addClass "main-toggle-animation"
      , 200)


    $("li.dismiss-times").click ->
      $("#nav-menu-bar").css "left", "-1000px"
      setTimeout(->
        $(".main-container").removeClass "main-toggle-animation"
      , 200)

  topSearchBar: ->
    that = this
    # Let open regardless of window click above
    $(".navbar-search").click (e) ->
      that.disabledEventPropagation(e)

      $(".navbar-header").css "left", "-1000px"
      $(".navbar-search-form").css "left", "0px"

    $(".navbar-search-form input").click (e) ->
      that.disabledEventPropagation(e)

    $(".navbar-search-form .submit-search").click (e) ->
      that.disabledEventPropagation(e)
      $(@).closest("form").submit()

  collapseHeaderTweaks: ->
    # Close Search on window click
    $(window).click ->
      $(".navbar-header").css "left", "0px"
      $(".navbar-search-form").css "left", "1000px"
    @topSearchBar()
    @sideMenu()


