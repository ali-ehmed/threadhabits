class SettingsController < ApplicationController
  before_action :authenticate_person!
  before_action :prepend_configuration, :except => [:update]
  @@current_settings = ""

  def profiles
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

  protected

    def person_params
      params.require(:person).permit(
                                      :first_name, :last_name, :email,
                                      :password, :password_confirmation,
                                      :phone_number, :about_you
                                     )
    end

  private

    def prepend_configuration
      @@current_settings = params[:action]
      store_current_location!
    end
end
