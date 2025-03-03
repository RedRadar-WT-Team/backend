# config/routes.rb

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
  # post 'create_account', to: 'users#create'
      resources :users, only: [:create]

      # users_path
      root 'home#index'
    end
  end
end
