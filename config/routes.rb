# config/routes.rb

Rails.application.routes.draw do
  root 'home#index'

  namespace :api do
    namespace :v1 do
      get '/profile', to: 'users#show', as: 'user_profile'

      resources :users, only: [:index, :show, :create, :update] do
        collection do
          get :by_email
        end
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

      resource :session, only: [:create, :destroy]

      resources :executive_orders_users, only: [:index, :create, :destroy]
      resources :representatives_users, only: [:index, :create, :destroy]
      delete "/representatives_users", to: "representatives_users#destroy"
      # delete "/", to: "representatives_users#destroy"
      
    end
  end
end
