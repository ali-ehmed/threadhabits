class ApplicationMailer < ActionMailer::Base
  default from: "Threadhabits <#{Threadhabits::Application.config.default_email}>"
  layout 'mailer'

  def test
    @greeting = "Hi Admin"
    mail to: "ali.ahmed.cs2014@gmail.com", subject: "Testing"
  end
end
