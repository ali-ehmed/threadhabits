Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  devise_for :people

  namespace :settings do
    SettingsHelper.settings_list.each do |list|
      get list[0] => "#{list[0]}#show"
      put list[0] => "#{list[0]}#update"
    end
  end

  get ":username" => "profiles#show", as: :profiles

  get 'welcome/index'
  root to: "welcome#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
