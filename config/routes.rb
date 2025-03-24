# config/routes.rb

Rails.application.routes.draw do
  root 'home#index'

  namespace :api do
    namespace :v1 do
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
      resource :users, only: [:create, :update, :show] 

      resources :executive_orders_users, only: [:create, :destroy]
      resource :representatives_users, only: [:create, :destroy]
      # delete "/representatives_users", to: "representatives_users#destroy"
      # delete "/", to: "representatives_users#destroy"
      
    end
  end
end
