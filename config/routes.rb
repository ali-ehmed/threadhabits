Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  devise_for :people, controllers: { registrations: "people/registrations" }

  resources :inbox, only: [:index, :create, :show]
  resources :messages, only: [:new, :create]
  resources :follow, only: [:index, :create, :update]

  resources :listings, except: [:show, :edit, :update, :destroy] do
    collection do
      get "details/:slug" => "listings#show", as: :detail
      get ":slug/edit" => "listings#edit", as: :edit
      put ":slug/update" => "listings#update", as: :update
      delete ":slug/destroy" => "listings#destroy", as: :destroy
      post "uploads/" => "listings#uploads", :constraints => { :format => 'json' }
      delete "delete_uploads/:upload_id" => "listings#destroy_uploads", :constraints => { :format => 'json' }
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

  root to: "home#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
