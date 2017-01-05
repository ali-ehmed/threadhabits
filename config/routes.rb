Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  devise_for :people, controllers: { registrations: "people/registrations" }

  resources :listings do
    collection do
      post "uploads/" => "listings#uploads", :constraints => { :format => 'json' }
      get "collect_size/:product_type_id" => "listings#collect_size"
    end
  end
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

  get '/' => "home#index", as: :fetch_listings
  # get "/" => "home#fetch_listings", as: :fetch_listings
  root to: "home#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
