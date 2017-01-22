class ProfilesController < ApplicationController
  before_action :set_profile

  def show
    if @person.has_address?
      set_geocode_location!(@person.address)
    end

    @listings = @person.listings
  end

  private

  def set_profile
    @person = Person.find_by_username(params[:username])

    if !@person
      redirect_to root_path, flash: { alert: "Page not found" }
    end
  end
end
