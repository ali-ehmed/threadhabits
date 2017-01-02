Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  devise_for :people

  resources :listings
  resources :settings, only: [:index] do
    collection do
      put "/" => "settings#update"
      post "/preferences" => "settings#preferences"
      SettingsHelper.settings_list.each do |list|
        get list[0]
      end
    end
  end

  get ":username" => "profiles#show", as: :profiles

  get 'welcome/index'
  root to: "welcome#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
