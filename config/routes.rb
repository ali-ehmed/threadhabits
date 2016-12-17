Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  devise_for :people
  get 'welcome/index'

  root to: "welcome#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
