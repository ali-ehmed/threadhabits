$(document).on "turbolinks:load", ->
  $('.profile .listing-tabs a').click (e) ->
    e.preventDefault()
    $(this).tab('show')
