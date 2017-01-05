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
    $('#new_listing').validate
      debug: true
      errorClass: "error"
      rules:
        "listing[name]": 'required'
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
          $upload.click()
        else
          $form.find("input[type='submit']").prop("disabled", false)
          alert "Couldn't Save Listing at the moment"
      error: (response) ->
        console.log "error"
        $form.find("input[type='submit']").prop("disabled", false)

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
      # Loading DOM to let the plugin initialized
      $(document).on "click", ".listing-uploads .fileinput-remove, .listing-uploads .kv-file-remove", ->
        setTimeout(->
          # Waiting for callback to complete (Already set on above plugin selectors)
          totalFiles = $("#listing_upload_photos").fileinput('getFilesCount')
          if totalFiles == 0
            $("#listing_upload_photos").rules 'add',
              required: true
        , 1000)
    , 1000)

    $("#listing_upload_photos").fileinput(
      uploadUrl: "/listings/uploads.json",
      uploadAsync: false,
      minFileCount: 1
      maxFileCount: 5
      showDrag: true
      showPreview: true
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
      totalFiles = $("#listing_upload_photos").fileinput('getFilesCount')
      if totalFiles > 0
        $("#listing_upload_photos").rules 'add',
          required: false
    ).on('filebatchuploadsuccess', (event, data) ->
      out = ''
      $.each data.files, (key, file) ->
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
    ).on 'filebatchuploaderror', (event, data) ->
      $("form").find("input[type='submit']").prop("disabled", false)

@Home =
  initializeFilters: ->
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
