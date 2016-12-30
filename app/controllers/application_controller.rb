class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_person!, :authorize_person!, if: :admin_controller?

  def landing_banner(flag = false) @landing_banner = !person_signed_in? && flag end;
  def google_service(flag = false) @google_service = flag end;

  def authorize_person!
    if !current_person.admin?
      redirect_to root_path, flash: { alert: "This area is restricted to admin users only" }
    end
  end

  def admin_controller?
    params[:controller].include?("admin")
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :username, :first_name, :last_name, :terms])
  end

  def store_current_location!
    session[:redirect_to] = request.url
  end

  def stored_location!
    session[:redirect_to] ||= nil
  end

  def set_geocode_location!(address)
    gon.current_location = {
      location: address.location,
      latitude: address.latitude,
      longitude: address.longitude,
      place_id: address.place_id,
      marker: {
        title: address.location
      }
    }
  end
end
