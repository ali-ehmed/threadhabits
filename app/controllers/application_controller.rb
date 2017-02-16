class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_person!, :authorize_person!, if: :admin_controller?
  before_action :set_filter_params

  helper_method :mobile_device?

  def landing_banner(flag = false) @landing_banner = !person_signed_in? && flag end;

  def authorize_person!
    if !current_person.admin?
      redirect_to root_path, flash: { alert: "This area is restricted to admin users only" }
    end
  end

  def admin_controller?
    params[:controller].include?("admin")
  end

  def store_config(options = {})
    session[:config] = options
  end

  def fetch_stored_config(attribute)
    session[:config][attribute.to_s] ||= nil
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

    gon.current_location
  end

  def set_filter_params
    @p = ActionController::Parameters.new({filters: {}})
    if params[:filters].present?
      @p[:filters] = params[:filters]
    end

    @p = @p.to_unsafe_h
  end

  def mobile_device?
    request.env["HTTP_USER_AGENT"] && request.env["HTTP_USER_AGENT"][/(iPhone|iPod|Android)/]
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :username, :first_name, :last_name, :terms])
  end
end
