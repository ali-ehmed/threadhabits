module Settings
  class AccountsController < BaseController
    include CommonSettings

    def show
      PersistenceResponse.new(self, settings_accounts_path, "Your Account Settings has been updated successfully.")
    end
  end
end
