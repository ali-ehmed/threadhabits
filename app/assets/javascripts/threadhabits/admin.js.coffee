Admin = {}

Admin.init = ->
  Admin.alertUsers.sendAlerts()

Admin.alertUsers =
  submitAlerts: (dialog, form) ->
    form.find("input[name='send_to_all']").on "change", ->
      $("li#user_alerts_emails_input").toggle()

    form.on "submit", (e) ->
      e.preventDefault()
      $form = $(this)

      formData = $form.serializeArray()
      if !$form.find("input[name='send_to_all']").is(":checked")
        formData.push({
          name: "send_to_all",
          value: "off"
        })
        formData.push({
          name: "recipient_emails",
          value: $("#recipient_emails").val()
        })
      else
        formData.push({
          name: "send_to_all",
          value: "on"
        })

      $.post($form.attr("action"), formData, (response) ->
        valid = response.status

        $.alert
          title: response.title
          content: response.message
          type: response.type
          buttons:
            ok:
              text: 'Ok'
              btnClass: 'btn-red'
              action: ->
                if valid
                  dialog.close()
      ).fail( (response) ->
        $.alert
          title: "Something went wrong",
          type: "red"
        return false
      )
  sendAlerts: ->
    $("#admin_write_message").click (e) ->
      e.preventDefault()
      $.get "/admin/user_alerts/write_message.json", (response) ->
        $.confirm({
          backgroundDismiss: false
          title: "Send Alerts to Users"
          content: response.html
          theme: 'material'
          buttons:
            formSubmit:
              text: 'Submit',
              btnClass: 'btn-blue',
              action: ->
                $("form#write_message_form").submit()
                return false
            cancel:
              text: 'Cancel'
          onContentReady: ->
            # initializing on pop ups
            $("select.tagging_select_emails").select2({
              placeholder: "Search User's Emails",
              allowClear: true
              tags: true
            })
#            $("textarea#user_alert_body").froalaEditor({
#              heightMin: 450,
#              heightMax: 450
#            })
            Admin.alertUsers.submitAlerts(this, this.$content.find('form'));
        })

$ ->
  Admin.init()