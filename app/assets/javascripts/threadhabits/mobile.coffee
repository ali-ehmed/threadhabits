@Mobile    = {}

class Native
  filtersTweaks: ->
    toggleSideMenu("#toggle-filter-menu", "#filter-menu")

    $("ul.sub-categories li a").each ->
      if $(this).text().toLowerCase() == Settings.getUrlParameter("filters[product_type]")
        $(this).parent().addClass "active-category"

  headerTweaks: ->
    topSearchBar()
    toggleSideMenu(".navbar-toggle.collapsed", "#navbar-menu")

  # Encapsulated
  disabledEventPropagation = (event) ->
    if event.stopPropagation
      event.stopPropagation()
    else if window.event
      window.event.cancelBubble = true

  toggleSideMenu = (elem, colapsedElem) ->
    # opening side menu
    $(elem).click (e) ->
      disabledEventPropagation(e)
      $(colapsedElem).addClass "toggle-side-menu"
      setTimeout(->
        $(".main-container").addClass "main-toggle-animation"
      , 200)


    $(".dismiss-times").click ->
      $(colapsedElem).removeClass "toggle-side-menu"
      setTimeout(->
        $(".main-container").removeClass "main-toggle-animation"
      , 200)

  topSearchBar = ->
    # Let open regardless of window click above
    $(".navbar-search").click (e) ->
      disabledEventPropagation(e)

      # collapsing header
      $(".navbar-header").css "left", "-1000px"  # Header
      $(".navbar-search-form").css "left", "0px" # Search Form

    $(".navbar-search-form input").click (e) ->
      disabledEventPropagation(e)

    $(".navbar-search-form .submit-search").click (e) ->
      disabledEventPropagation(e)
      $(@).closest("form").submit()

    # Close Search on window click
    $(".cancel-search").click ->
      $(".navbar-header").css "left", "0px"
      $(".navbar-search-form").css "left", "1000px"


@Mobile = new Native



