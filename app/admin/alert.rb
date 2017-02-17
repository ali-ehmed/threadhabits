ActiveAdmin.register_page "Alerts" do
  menu false

  content do
    # action code
  end

  page_action :message, method: :get do
    people = Person.select(:id, :email, :first_name, :last_name)
    respond_to do |format|
      format.json { render json: { html: render_to_string(partial: "admin/alerts/form.html.haml", layout: false, locals: { people: people }) } }
    end
  end

  page_action :send_alerts, method: :post do
    alert_all = params[:send_to_all]
    emails    = params[:recipient_emails]
    body      = params[:body]
    subject   = params[:subject].blank? ? nil : params[:subject]

    valid = true
    msg   = ""

    errors = [
        "Recipient's Email can't be blank",
        "Body can't be blank"
    ]

    [emails, body].each_with_index do |content, i|
      if alert_all == "off"
        unless content.present?
          valid = false
          msg = errors[i]
        end

        break if !valid
      else
        if body.blank?
          valid = false
          msg = errors[1]
        end
      end
    end

    if !valid
      render json: { status: false, message: msg, title: "Errors", type: "red" } and return
    end

    if alert_all == "off"
      people = Person.where(email: emails.split(",").compact.uniq)
    else
      people = Person.all
    end

    people.each do |p|
      AlertMailer.public_alert(p, body, subject).deliver
    end

    render json: { status: true, message: "Users have been sent email(s) successfully.", title: "Success!", type: "green" }
  end

  page_action :upload_content_images, method: :post do
    S3_BUCKET.presigned_post(key: "alertUploads/#{SecureRandom.uuid}/${filename}", success_action_status: '201', acl: 'public-read')
    render json: 200
  end
end
