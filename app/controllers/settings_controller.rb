class SettingsController < ApplicationController
  before_action :authenticate_person!
  before_action :prepend_configuration, :except => [:update]
  before_action only: [:profiles] { google_service(true) }
  @@current_settings = ""

  def profiles
    if current_person.has_address?
      set_geocode_location!(current_person.address)
    else
      current_person.build_address
    end
  end

  def accounts
  end

  def notifications
    @preferences = current_person.preferences.notifications.first.try(:activated) || []
  end

  def payments
    #code
  end

  def update
    @current_settings = @@current_settings
    if current_person.update_attributes(person_params)
      bypass_sign_in(current_person)
      redirect_to stored_location!, notice: "#{@current_settings.capitalize} settings updated successfully"
    else
      flash[:alert] = "Review errors below"
      render @current_settings.to_sym
    end
  end

  def preferences
    @preference = current_person.preferences.notifications.first
    if @preference.blank?
      @preference = current_person.preferences.notifications.build(preference_type: "Notification")
    end
    @preference.data = params[:notification_preferences] || {}
    @preference.save
    redirect_to notifications_settings_path, notice: "Notifications settings updated successfully"
  end

  private
    def person_params
      permitted_attributes =  case @@current_settings.to_sym
                              when :profiles
                               [:first_name, :last_name, :email,
                               :password, :password_confirmation,
                               :phone_number, :about_you, :avatar, :cover_image,
                               :address_attributes => [:id, :location, :place_id, :latitude, :longitude]]
                             when :accounts
                               [:email, :username, :password, :password_confirmation, :current_password]
                             end
      params.require(:person).permit(permitted_attributes)
    end

    def prepend_configuration
      @@current_settings = params[:action]
      store_current_location!
    end
end
