Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :users do
        resources :items do
          resources :notifications
        end
      end
    end
  end

  post '/auth/login', to: 'sessions#login'

  # Defines the root path route ("/")
  root "home#index"
end
