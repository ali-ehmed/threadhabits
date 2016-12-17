class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_person!, :authorize_person!, if: :admin_controller?

  def landing_banner(flag = false) @landing_banner = !person_signed_in? && flag end;

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
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :first_name, :last_name, :terms])
  end
end
