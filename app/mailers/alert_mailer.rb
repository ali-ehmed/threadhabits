class AlertMailer < ApplicationMailer
  include Roadie::Rails::Automatic
  default from: Rails.application.secrets.admin_email
  layout 'mailer'

  def public_alert(person, body, subject)
    @person   = person
    @body     = body
    subject ||= "Welcome to Threadhabits"
    mail(to: person.email, subject: subject)
  end
end
