module CommonSettings
  extend ActiveSupport::Concern

  included do
    before_action except: [:update] do
      session[:path] = request.url
    end
  end
end
