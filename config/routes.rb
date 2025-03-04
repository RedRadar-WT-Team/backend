# config/routes.rb

Rails.application.routes.draw do
  root 'home#index'

  get "up" => "rails/health#show", as: 
  :rails_health_check

  namespace :api do
    namespace :v1 do
      resources :executive_orders, only: [:index]
    end
  end
end