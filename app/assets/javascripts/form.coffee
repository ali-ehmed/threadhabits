validateRegistration = ->
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

validateListings = ->
  $('#new_listing').validate
    debug: true
    rules:
      "listing[name]": 'required'
      "listing[description]": 'required'
      "product": 'required'
      "listing[price]": 'required'
      "listing[condition]": 'required'
      "listing[sizes]": 'required'
      "listing[company_id]": 'required'
    messages:
      product: 'Product Type must be selected'
      "listing[sizes]": 'Sizes must be selected'
    submitHandler: (form) ->
      form.submit()
      return

$(document).on "turbolinks:load", ->
  $("#listing_company_id").select2()
  $.validator.setDefaults
    errorPlacement: (error, element) ->
      $(element).closest(".form-group").after(error)
      return
    invalidHandler: (form, validator) ->

  $('body.registrations.new').click ->
    validateRegistration()

  $('body.listings.new').click ->
    validateListings()

    $(".product-type-listing-input").on "change", ->
      $.get("/listings/collect_size/#{$(this).val()}.js", (data) ->
        validateListings()
        console.log "Sizes Collection Completed"
      ).fail(->
        alert "Couldn't fetch sizes at the moment"
        return
      )
