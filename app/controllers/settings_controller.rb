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
    #code
  end

  def payments
    #code
  end

  def update
    if current_person.update_attributes(person_params)
      redirect_to stored_location!, notice: "#{@@current_settings.capitalize} settings updated successfully"
    else
      flash[:alert] = "Review errors below"
      render @@current_settings.to_sym
    end
  end

  private
    def person_params
      permitted_attributes = case @@current_settings.to_sym
                              when :profiles
                               [:first_name, :last_name, :email,
                               :password, :password_confirmation,
                               :phone_number, :about_you, :address_attributes => [:id, :location, :place_id, :latitude, :longitude]]
                             end
      params.require(:person).permit(permitted_attributes)
    end

    def prepend_configuration
      @@current_settings = params[:action]
      store_current_location!
    end
end
