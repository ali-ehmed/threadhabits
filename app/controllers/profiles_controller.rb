class ProfilesController < ApplicationController
  before_action :authenticate_person!, :set_profile

  def show
  end

  private

  def set_profile
    @person = Person.find_by_username(params[:username])

    if !@person
      redirect_to root_path, flash: { alert: "Page not found" }
    end
  end
end
