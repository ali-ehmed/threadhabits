module SettingsHelper
  module_function

  # This helper list is based on the Settings Namespace Controllers in controllers directory
  # The controller name for Settings Namespace must be include in the below array
  def settings_list
    {
      "profiles" => "Profile Info",
      "accounts" => "Account",
      "notifications" => "Notifications",
      "payments" => "Payment Info"
    }
  end
end
