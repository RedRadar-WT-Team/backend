# config/routes.rb

Rails.application.routes.draw do
  root 'home#index'

  namespace :api do
    namespace :v1 do
<<<<<<< HEAD
      get '/profile', to: 'users#show', as: 'user_profile'

=======
>>>>>>> e505044a97628cdac2d9df349e77680ee16fea98
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

      resources :executive_orders_users, only: [:create, :destroy]
      resources :representatives_users, only: [:create, :destroy]
      resource :session, only: [:create, :destroy]
      delete "/representatives_users", to: "representatives_users#destroy"
      # delete "/", to: "representatives_users#destroy"
    end
  end
end
