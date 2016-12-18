class AdminService
  def call
    Person.find_or_create_by!(username: Rails.application.secrets.admin_username) do |admin|
      admin.first_name = Rails.application.secrets.admin_first_name
      admin.last_name = Rails.application.secrets.admin_last_name
      admin.email = Rails.application.secrets.admin_email
      admin.password = Rails.application.secrets.admin_password
      admin.password_confirmation = Rails.application.secrets.admin_password
      admin.skip_confirmation!
      admin.admin = true
    end
  end
end
