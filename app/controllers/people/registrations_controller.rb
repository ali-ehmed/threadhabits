class People::RegistrationsController < Devise::RegistrationsController
  def create
    build_resource(sign_up_params)
    if request.xhr?
      render json: resource.valid_attribute?(params[:attribute_name].to_sym)
    else
      super
    end
  end
end
