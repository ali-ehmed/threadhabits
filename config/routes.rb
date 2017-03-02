Rails.application.routes.draw do
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/devel/emails"
  end

  ActiveAdmin.routes(self)
  devise_for :people, controllers: { registrations: "people/registrations" }

  resources :inbox, only: [:index, :create, :show]
  resources :messages, only: [:new, :create]
  resources :follow, only: [:index, :create, :update]

  namespace :payments do
    # Braintree routes - Not using currently
    # get "/new" => "braintree#new", as: :purchase_new
    # post "/merchant" => "braintree#create", as: :merchant
    # post "/purchase" => "braintree#purchase", as: :purchase
    # post "/braintree_webhook" => "braintree#braintree_webhook", as: :sub_merchant_webhook

    # Paypal routes
    get "/checkout_paypal" => "paypal#checkout", as: :checkout_paypal
    post "/webhook" => "paypal#webhook"
    post "/confirm" => "paypal#confirm", as: :confirm_checkout
  end

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
      put "/remove_avatar" => "settings#remove_avatar"
      SettingsHelper.settings_list.each do |list|
        get list[0]
      end
    end
  end

  get "profiles/:username" => "profiles#show", as: :profiles

  get '/inventory' => "home#inventory"
  get '/designers' => "home#designers"
  get '/verify_unread_message' => "home#verify_unread_message"
  get 'about_us' => "home#about_us", as: :about_us
  get 'contact_us' => "home#contact_us"

  root to: "home#inventory"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
