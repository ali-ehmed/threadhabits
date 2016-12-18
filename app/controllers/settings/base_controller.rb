module Settings
  class BaseController < ApplicationController
    class PersistenceResponse < SimpleDelegator
      def initialize(object, path, message)
        object.session[:path]    = path
        object.session[:message] = message
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
  end
end
