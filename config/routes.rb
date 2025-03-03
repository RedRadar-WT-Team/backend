# config/routes.rb

Rails.application.routes.draw do
  # post 'create_account', to: 'users#create'
  resources :users, only: [:create]
  # users_path
  root 'home#index'
end
