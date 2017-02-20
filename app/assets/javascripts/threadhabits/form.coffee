@Follow =
  initializeFollowings: ->
    $("#follow-person").on "click", (e) ->
      e.preventDefault()
      $elem = $(this)
      $elem.prop "disabled", true
      # console.log $elem.attr("data-method-type")
      $.ajax
        type: $elem.attr("data-method-type")
        url: $elem.attr("href")
        dataType: "json"
        complete: ->
          $elem.prop "disabled", false
        success: (response) ->
          $elem.attr("data-method-type", response.method)
          $elem.attr("href", response.url)
          if $elem.attr("data-follow") == "false"
            $elem.html("Unfollow")
            $elem.attr("data-follow", "true")
          else
            $elem.attr("data-follow", "false")
            $elem.html("Follow")
          $(".profile-desc .followings span.value").text response.followings
          $(".profile-desc .followers span.value").text response.followers
        error: (response) ->
          console.log "error"

@Inbox =
  validateForm: ->
    that = this
    $('#messageForm').validate
      rules:
        "message[body]": 'required'
      submitHandler: (form) ->
        that.submitMessage(form)
        return
    $('#messageFormInbox').validate
      rules:
        "message[body]": 'required'
      submitHandler: (form) ->
        form.submit()
        return

  submitMessage: (form) ->
    that = this
    $form = $(form)
    $form.find("button[type='submit']").html("<i class='fa fa-spinner fa-pulse'></i> Sending...")
    action = $form.attr("action")
    method = $form.attr("method")
    $modal_body = $form.closest(".modal-body")
    $.ajax
      type: method
      url: action
      data: $form.serialize()
      dataType: "json"
      complete: ->
        $form.find("button[type='submit']").hide()
        $modal_body.find(".message-body-form").hide()
      success: (response) ->
        if response.status == 200
          $modal_body.find(".message-body-success").show()
          $modal_body.find(".inbox-link").attr "href", response.inbox_path
        else
          $modal_body.find(".message-body-success").hide()
          $modal_body.find(".message-body-failure").show()
      error: (response) ->
        $modal_body.find(".message-body-success").hide()
        $modal_body.find(".message-body-failure").show()
        console.log "error"

  initializeMessageBox: ->
    $("#message-box-link").click (e) ->
      e.preventDefault()
      $.get $(this).data("url"), (response) ->
        console.log "Hello"
        $("#messageModal").modal({
            show: true
            backdrop: "static"
        })
        $("#messageModal").on 'shown.bs.modal', ->
          Inbox.validateForm();
          Inbox.hideMessageBox();

  hideMessageBox: ->
    $("#messageModal").on 'hidden.bs.modal', ->
      $(".message-box").empty()

@Profiles =
  validateForm: ->
    $("form#editProfilesForm").validate
      rules:
        "person[first_name]": 'required'
        "person[last_name]": 'required'
        "person[address_attributes][location]": 'required'
        "person[about_you]": 'required'
        "person[facebook_profile]":
          url: true
        "person[instagram_profile]":
          url: true
        "person[twitter_profile]":
          url: true

@Registrations =
  validateForm: ->
    remoteUrl = "/people.json?"
    remoteMethod = "POST"
    $('#new_person').validate
      rules:
        "person[first_name]": 'required'
        "person[last_name]": 'required'
        "person[username]":
          required: true
          remote:
            url: remoteUrl + "attribute_name=username"
            type: remoteMethod
        "person[email]":
          required: true
          email: true
          remote:
            url: remoteUrl + "attribute_name=email"
            type: remoteMethod
        "person[password]":
          required: true
          minlength: 8
        "person[password_confirmation]":
          minlength: 8
          equalTo : "#person_password"
        "person[terms]": 'required'
      messages:
        "person[username]":
          remote: "Username already in use!"
        "person[email]":
          remote: "Email already in use!"
        "person[password_confirmation]":
          equalTo: "Password donot match correctly"
        "person[terms]": "Terms & Conditions must be accespted"
      submitHandler: (form) ->
        form.submit()
        return

@Listings =
  redirect_to: ""
  validateForm: ->
    that = this
    remoteUrl = $('form.listing-form').attr("action") + ".json?"
    remoteMethod =  if $('form.listing-form').data("new-record")
                      "POST"
                    else
                      "PUT"

    $('form#listingForm').validate
      debug: true
      errorClass: "error"
      rules:
        "listing[name]":
          required: true
          remote:
            url: remoteUrl + "attribute_name=slug"
            type: remoteMethod
        "listing[description]": 'required'
        "listing[product_type_id]": 'required'
        "listing[price]": 'required'
        "listing[condition]": 'required'
        "listing[size_id]": 'required'
        "listing[company_id]": 'required'
        "upload_photos[]":
          required: true
          extension: "png|jpg|jpeg"
      messages:
        "listing[name]":
          remote: "This item name is already taken"
        "listing[product_type_id]": 'Product Type must be selected'
        "listing[size_id]": 'Sizes must be selected'
        "upload_photos[]": 'Please select Images for your listing.'
      submitHandler: (form) ->
        console.log form
        that.submitListings(form)
        return

  submitListings: (form) ->
    that = this
    $form = $(form)
    $form.find("input[type='submit']").prop("disabled", true)
    $form.find("input[type='submit']").val("Saving Your Listing...")
    action = $form.attr("action")
    method = $form.attr("method")
    $upload = $form.find(".listing-uploads .fileinput-upload")
    $.ajax
      type: method
      url: action
      data: $form.serialize()
      dataType: "json"
      success: (response) ->
        if response.status == 200
          that.redirect_to = response.redirect_to
          totalFiles = $("#listing_upload_photos").fileinput('getFilesCount')
          if $form.data("new-record") == false && totalFiles == 0
            window.location.href = that.redirect_to
          else
            $upload.click()
        else
          $form.find("input[type='submit']").prop("disabled", false)
          console.log "Couldn't Save Listing at the moment"
      error: (response) ->
        console.log "error"
        $form.find("input[type='submit']").prop("disabled", false)

  updateNumberOfFilesText: ->
    frames = $(".listing-uploads .file-preview-frame").length
    text = frames + " " + (if frames > 1 then "files" else "file")
    $(".file-caption-name").html('<i class="glyphicon glyphicon-file kv-caption-icon"></i>' + text + " selected")

  # For New Listing Check
  toggleFileUploadValidation: ->
    $(document).on "click", ".listing-uploads .fileinput-remove, .listing-uploads .kv-file-remove", ->
      setTimeout(->
        # Waiting for callback to complete (Already set on above plugin selectors)
        totalFiles = $("#listing_upload_photos").fileinput('getFilesCount')
        if totalFiles == 0
          $("#listing_upload_photos").rules 'add',
            required: true
      , 1000)

  # For Edit Listing Check
  refreshFileInput: (imgsPath = [], imgsConfig = []) ->
    that = this

    parsedConfig = []
    imgsConfig.forEach (val, index) ->
      console.log index
      parsed = JSON.parse(val)
      parsedConfig.push parsed

      # Waiting for initial preview to load all the images
      setTimeout(->
        uploadId = parsed.upload_id
        # Removing default class ".kv-file-remove" to add custom behavior
        $(".listing-uploads").find("button.kv-file-remove").removeClass("kv-file-remove").addClass "remove-listing-btn"

        removeElems = removeElems = $(".listing-uploads").find("button.remove-listing-btn")

        # Remove Listings From Frame
        $(removeElems[index]).on "click", ->
          elem = $(this)
          removeElems = $(".listing-uploads").find("button.remove-listing-btn")

          if removeElems.length > 1
            elem.css "cursor", "not-allowed"
            $(".listing-uploads").find(".btn").each ->
              $(this).prop "disabled", true

            $('#file-upload-error-container').empty()
            $('#file-upload-error-container').hide()
            elem.closest(".file-preview-frame").addClass "removal-frame"
            elem.closest(".file-preview-frame").prepend("<img src='/assets/loading-sm.gif' class='listing-removal-loader' />")

            $.ajax
              url: '/listings/delete_uploads/' + uploadId
              type: 'DELETE'
              success: (result) ->
                elem.css "cursor", "pointer"
                $(".listing-uploads").find(".btn").each ->
                  $(this).prop "disabled", false
                # If There are no images in the frame setting File Input Validation
                elem.closest(".file-preview-frame").fadeOut 500, ->
                  elem.closest(".file-preview-frame").remove()
                  that.updateNumberOfFilesText()
                return
              error: ->
                alert "Something went wrong"
          else
            out = "<ul class='list-unstyled'><li>Atleast 1 Image must be added in a listing</li></ul>"
            $('#file-upload-error-container').addClass ""
            $('#file-upload-error-container').append out
            $('#file-upload-error-container').fadeIn 'slow'

            elem.prop "disabled", true
            window.setTimeout(->
              $('#file-upload-error-container').fadeOut "slow", ->
                $('#file-upload-error-container ul').remove()
              elem.prop "disabled", false
            , 2000)

      , 100)

    # Setting Validation of File Input
    if imgsPath.length >= 1
      $("#listing_upload_photos").rules 'add',
        required: false

      minFileCount = 0
    else
      minFileCount = 1

    # Refreshing File Input
    $("#listing_upload_photos").fileinput('refresh', {
      initialPreview: imgsPath
      minFileCount: minFileCount
      initialPreviewConfig: parsedConfig
      showBrowse: true
      initialPreviewFileType: 'image'
      initialPreviewAsData: false
      overwriteInitial: false
      initialPreviewShowDelete: true
    })

  # Not used yet!!!
  scrollingFileInput: ->
    (($) ->
      element = $('.listing-uploads')
      if element.length
        # Getting top of note to make the distance b/w note & header
        originalY = element.offset().top
        # Getting Top of footer to make the distance b/w note & footer
        footerY = $("footer").offset().top - 700
        topMarginFromBottom = 120
        element.css 'position', 'relative'

        $(window).on 'scroll', (event) ->
          scrollTop = $(window).scrollTop()

          if scrollTop < originalY
            totalMargin = 0 # setting top margin
          else if scrollTop > footerY
            totalMargin = scrollTop - topMarginFromBottom # setting bottom margin
          else
            totalMargin = scrollTop - originalY + 480

          element.stop(false, false).animate {
            top: totalMargin
          }, 300
          return
      return
    ) jQuery

  infiniteScroll: ->
    if $('#infinite-scrolling').size() > 0
      $(window).on 'scroll', ->
        more_listings_url = $('.pagination li.next a').attr('href')
        if more_listings_url && $(window).scrollTop() > $(document).height() - $(window).height() - 60
            $('.pagination').html('<i class="fa fa-spinner fa-pulse fa-2x fa-fw"></i><strong class="load-more-listing">Loading More Listings...</strong>')
            $.getScript more_listings_url
        return
      return

  initializeListingsForm: ->
    that = this
    that.validateForm()

    $("#listing_company_id").select2()

    $(".product-type-listing-input").on "change", (e) ->
      $.get("/listings/collect_size/#{$(this).val()}.js", (data) ->
        that.validateForm()
        console.log "Sizes Collection Completed"
      ).fail(->
        alert "Couldn't fetch sizes at the moment"
        return
      )

    setTimeout(->
      $(".listing-uploads .fileinput-remove").remove()
    , 100)

    $(document).on "click", ".listing-uploads .kv-file-remove", ->
      setTimeout(->
        that.updateNumberOfFilesText()
      , 1000)


    $("#listing_upload_photos").fileinput(
      uploadUrl: "/listings/uploads.json",
      uploadAsync: false,
      minFileCount: 1
      maxFileCount: 5
      showDrag: true
      showPreview: true
      showRemove: false
      showBrowse: true,
      browseOnZoneClick: true
      previewFileType: "png",
      allowedFileExtensions: ["png", "jpg", "jpeg"]
      elErrorContainer: '#file-upload-error-container'
      showDrag: true
    ).on('filebatchpreupload', (event, data, id, index) ->
      $('#file-upload-success-container').html('<h4>Upload Status</h4><ul></ul>').hide()
      return
    ).on('fileselect', (event, numFiles, label) ->
      that.updateNumberOfFilesText()
      totalFiles = $("#listing_upload_photos").fileinput('getFilesCount')
      if totalFiles > 0
        $("#listing_upload_photos").rules 'add',
          required: false
    ).on('filebatchuploadsuccess', (event, data) ->
      out = ''
      $.each data.files, (key, file) ->
        if file
          fname = file.name
          out = out + '<li>' + 'Uploaded file # ' + key + 1 + ' - ' + fname + ' successfully.' + '</li>'
        return
      $('#file-upload-success-container ul').append out
      $('#file-upload-success-container').fadeIn 'slow'

      setTimeout(->
        console.log event
        @location.href = that.redirect_to
      , 3000)
      return
    ).on('filebatchuploaderror', (event, data) ->
      $("form").find("input[type='submit']").prop("disabled", false)
    ).on 'fileerror', (event, data) ->
      $("form").find("input[type='submit']").prop("disabled", false)
      $("form").find("input[type='submit']").val("Submit")

@Home =
  initializeFilters: ->
    # Scroll Plugin
    $.fn.followTo = (pos) ->
      $this = this
      $window = $(window)
      # Setting Start Position
      topOffset = 5

      $this.css "z-index", "1"

      $window.scroll (e) ->
        # Stops when scroll position crosses "pos"
        if $window.scrollTop() > pos
          stopPos = pos
          $this.css
            position: 'relative'
            top: stopPos
        else if $window.scrollTop() > topOffset
          # Starts
          $this.css
            position: 'fixed'
            top: 100
        else if $window.scrollTop() < topOffset
          # Stops back where started
          $this.css
            position: 'relative'
            top: 0
        return
      return

    # only if mobile devices
    unless gon.mobile_device
      $('.listing-filters form').followTo(($("footer").offset().top + 2000));

    nonLinearSlider = nonLinearSlider = document.getElementById('nonlinearRangePriceSlider')
    nodes = [
    	document.getElementById('lower-price-span')
    	document.getElementById('upper-price-span')
    ]
    nodesInput = [
    	document.getElementById('lower-price-input')
    	document.getElementById('upper-price-input')
    ]

    noUiSlider.create nonLinearSlider,
      connect: true
      behaviour: 'tap'
      start: [
        nodesInput[0].value,
        nodesInput[1].value
      ]
      range:
        'min': [ 0 ]
        'max': [ 15000 ]


    nonLinearSlider.noUiSlider.on 'update', (values, handle, unencoded, isTap, positions) ->
      nodes[handle].innerHTML  = parseInt(values[handle])
      nodesInput[handle].value = parseInt(values[handle])

      return

    $('a.collapse-filter-link').on 'click', (e) ->
      target = $(this).find("span")
      if target.html() == "-"
        target.html "+"
      else
        target.html "-"
$ ->
  $.validator.setDefaults
    errorPlacement: (error, element) ->
      if $(element).hasClass "file-field-input"
        $(error).addClass "file-field-input-error"
      $(element).closest(".form-group").after(error)
      return
    invalidHandler: (form, validator) ->
