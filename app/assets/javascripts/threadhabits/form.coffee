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
  validateForm: ->
    $('#new_listing').validate
      debug: true
      rules:
        "listing[name]": 'required'
        "listing[description]": 'required'
        "listing[product_type]": 'required'
        "listing[price]": 'required'
        "listing[condition]": 'required'
        "listing[size]": 'required'
        "listing[company_id]": 'required'
      messages:
        product: 'Product Type must be selected'
        "listing[sizes]": 'Sizes must be selected'
      submitHandler: (form) ->
        form.submit()
        return

  initializeListingsForm: ->
    that = this
    that.validateForm()

    $("#listing_company_id").select2()

    $(".add-more-uploads").on "click", (e) ->
      e.preventDefault()
      parent = $(@).closest(".wrapper-upload")
      console.log parent
      parent.before "<div class='col-md-4'>#{wrapper_upload.html()}</div>"

    $(".product-type-listing-input").on "change", (e) ->
      $.get("/listings/collect_size/#{$(this).val()}.js", (data) ->
        that.validateForm()
        console.log "Sizes Collection Completed"
      ).fail(->
        alert "Couldn't fetch sizes at the moment"
        return
      )

$ ->
  $.validator.setDefaults
    errorPlacement: (error, element) ->
      $(element).closest(".form-group").after(error)
      return
    invalidHandler: (form, validator) ->
