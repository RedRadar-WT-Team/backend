# config/routes.rb

Rails.application.routes.draw do
  root 'home#index'
  
  namespace :api do
    namespace :v1 do
      # post 'create_account', to: 'users#create'
      resources :users, only: [:create]
      resources :representatives, only: [:index]
    end
  end
end
