module CommonSettings
  extend ActiveSupport::Concern

  included do
    before_action only: [:update] do
      @path    = session[:path]
      @message = session[:message]
    end
  end

  def update
    if current_person.update_attributes(person_params)
      redirect_to @path, notice: @message
    else
      flash[:alert] = "Review errors below"
      render :show
    end
  end
end
