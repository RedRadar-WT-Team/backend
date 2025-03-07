# config/routes.rb

Rails.application.routes.draw do
  root 'home#index'

  namespace :api do
    namespace :v1 do
      post '/login', to: 'sessions#create'  # log in
      delete '/logout', to: 'sessions#destroy'  # log out
      get '/profile', to: 'users#show'

      resources :users, only: [:index, :show, :create, :update, :edit] do
      end

      resources :representatives, only: [:index, :show, :create] do
        collection do
          get :search, action: :index
          get :details, action: :show
        end
      end
      resources :executive_orders, only: [:index, :show, :create] do
        collection do
          get :recent
        end
      end
      resources :executive_orders_users, only: [:create, :destroy]
      resources :representatives_users, only: [:create, :destroy]
    end
  end
end
