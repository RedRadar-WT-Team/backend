# config/routes.rb

Rails.application.routes.draw do
  root 'home#index'
  namespace :api do
    namespace :v1 do
      # post 'create_account', to: 'users#create'
      resources :users, only: [:create]
      resources :representatives, only: [:index] do
        collection do
          get :search, action: :index
          get :details, action: :show
        end
      end
      resources :executive_orders, only: [:index, :show] do
        collection do
          get :recent
        end
      end
    end
  end
end
