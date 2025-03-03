# config/routes.rb

Rails.application.routes.draw do
  post 'create_account', to: 'users#create'
  root 'home#index'
end
