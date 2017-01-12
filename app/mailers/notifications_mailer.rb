class NotificationsMailer < ActionMailer::Base
  include Roadie::Rails::Automatic
  default from: "Threadhabits <#{Threadhabits::Application.config.default_email}>"
  layout 'mailer'

  def messages(message, listing)
    @sender = message.sender
    @receiver = message.receiver
    @body = message.body
    @message = message
    @listing = listing
    mail to: @receiver.email, subject: "New Message From #{@sender.full_name}"
  end
end
