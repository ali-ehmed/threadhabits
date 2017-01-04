previewImageElem = (options = {}) ->
  img = $('<img/>',
    id: 'dynamic'
    width: (options.width || 250)
    height: (options.height || "auto"))

  img

window.clearPreviewImage = (elem) ->
  parent = $(elem).closest('.image-preview')
  parent.attr('data-content', '').popover 'hide'
  parent.find('.image-preview-filename').val ''
  parent.find('.image-preview-clear').hide()
  parent.find('.image-preview-input input:file').val ''
  parent.find('.image-preview-input-title').text 'Browse'
  return

window.createPreviewImage = (elem, options = {}) ->
  img = previewImageElem(options)
  # Create the preview image
  file = elem.files[0]
  reader = new FileReader

  # Set preview image into the popover data-content
  reader.onload = (e) ->
    img.attr 'src', e.target.result
    if !options.removeDefault
      parent = $(elem).closest('.image-preview')
      parent.find('.image-preview-input-title').text 'Change'
      parent.find('.image-preview-clear').show()
      parent.find('.image-preview-filename').val file.name
      parent.attr('data-content', $(img)[0].outerHTML).popover 'show'
    else
      $(options.element).replace($(img)[0].outerHTML)
    return

  reader.readAsDataURL file

$(document).on "turbolinks:load", ->
  $('.profile .listing-tabs a').click (e) ->
    e.preventDefault()
    $(this).tab('show')

  closebtn = $('<button/>',
    type: 'button'
    text: 'x'
    id: 'close-preview'
    style: 'font-size: initial;')

  closebtn.attr 'class', 'close pull-right'

  $.each $(".image-preview"), ->
    content = 'There\'s no image'
    if $(this).data("preview-img")
      img = previewImageElem()
      img.attr 'src', $(this).data("preview-img")
      content = img

    # Set the popover default content
    $(this).popover
      trigger: 'hover'
      html: true
      title: '<strong>Preview</strong>' + $(closebtn)[0].outerHTML
      content: content
      placement: 'top'
