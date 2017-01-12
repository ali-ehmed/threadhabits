class DeviseMailer < Devise::Mailer
  include Roadie::Rails::Automatic
  layout 'mailer'
end
