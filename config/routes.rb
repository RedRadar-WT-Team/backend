# config/routes.rb

Rails.application.routes.draw do
  get 'users/create'
  root 'home#index'
end
