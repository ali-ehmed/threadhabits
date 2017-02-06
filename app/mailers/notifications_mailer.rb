class NotificationsMailer < ActionMailer::Base
  include Roadie::Rails::Automatic
  default from: "Threadhabits <#{Threadhabits::Application.config.default_email}>"
  layout 'mailer'

  def messages_alert(message, listing)
    @sender = message.sender
    @receiver = message.receiver
    @body = message.body
    @message = message
    @listing = listing
    mail to: @receiver.email, subject: "New Message From #{@sender.full_name}"
  end

  def sign_up_alert(person)
    @person = person
    mail to: Rails.application.secrets.admin_email, subject: "New Sign Up"
  end
end
