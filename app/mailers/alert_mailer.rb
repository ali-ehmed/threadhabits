class AlertMailer < ApplicationMailer
  default from: Rails.application.secrets.admin_email

  def public_alert(person, body, subject = "Welcome to Threadhabits")
    @person = person
    @body   = body
    mail(to: person.email, subject: subject)
  end
end
