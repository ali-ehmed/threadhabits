module SettingsHelper
  module_function

  def settings_list
    {
      "profiles" => {
        name: "Profile Info",
        path: defined?(profiles_settings_path) ? profiles_settings_path : nil
      },
      "accounts" => {
        name: "Account",
        path: defined?(accounts_settings_path) ? accounts_settings_path : nil
      },
      "notifications" => {
        name: "Notifications",
        path: defined?(notifications_settings_path) ? notifications_settings_path : nil
      },
      "payments" => {
        name: "Payment Info",
        path: defined?(payments_settings_path) ? payments_settings_path : nil
      }
    }
  end
end
