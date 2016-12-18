module Settings
  class ProfilesController < BaseController
    include CommonSettings

    def show
      PersistenceResponse.new(self, settings_profiles_path, "Your profile has been updated successfully.")
    end
  end
end
