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
#                dialog.close() if valid

      ).fail( (response) ->
        $.alert
          title: "Something went wrong",
          type: "red"
        return false
      )

  sendAlerts: ->
    $("#admin_write_message").click (e) ->
      e.preventDefault()
      $.get "/admin/alerts/message.json", (response) ->
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

            params = gon.s3_presigned_data.fields
            $("textarea#user_alert_body").froalaEditor({
              charCounterCount: true
              heightMin: 400,
              heightMax: 450
              tableMultipleStyles: false
              dragInline: true,
              imageAllowedTypes: ['jpeg', 'jpg', 'png']
              imageMove: true
              fileAllowedTypes: ['image/png', 'image/jpeg', 'image/gif']
              toolbarButtons: [
                'bold', 'fontSize', 'strikeThrough', 'fontFamily', 'color', 'italic', 'underline',
                'insertImage', 'insertLink', 'undo', 'redo', 'paragraphStyle', '|', 'paragraphFormat',
                'align', 'insertTable', 'quote', 'selectAll', 'formatOL', 'formatUL', 'indent', 'outdent',
                '-'
              ]
              imageUploadParams: gon.s3_presigned_data.fields
              imageUploadMethod: "POST"
              imageUploadURL: "https://s3-us-west-2.amazonaws.com/threadhabits"
            })

            Admin.alertUsers.submitAlerts(this, this.$content.find('form'));
        })

$ ->
  Admin.init()