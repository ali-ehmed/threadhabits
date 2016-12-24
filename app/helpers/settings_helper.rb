module SettingsHelper
  module_function

  # This helper list is based on the Settings Namespace Controllers in controllers directory
  # The controller name for Settings Namespace must be include in the below array
  def settings_list
    {
      "profiles" => {
        name: "Profile Info",
        path: defined?(settings_profiles_path) ? settings_profiles_path : nil
      },
      "accounts" => {
        name: "Account",
        path: defined?(settings_accounts_path) ? settings_accounts_path : nil
      },
      "notifications" => {
        name: "Notifications",
        path: defined?(settings_notifications_path) ? settings_notifications_path : nil
      },
      "payments" => {
        name: "Payment Info",
        path: defined?(settings_payments_path) ? settings_payments_path : nil
      }
    }
  end
end
