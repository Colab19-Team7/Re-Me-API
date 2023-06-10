Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :users
      get '/categories', to: 'categories#index'
      get '/categories/:name', to: 'categories#show'
      delete 'categories/:name', to: 'categories#destroy'
      resources :items do
        resources :notifications
      end
    end
  end

  get 'test', to: 'test#index'
  post 'test', to: 'test#test'

  post '/auth/login', to: 'sessions#login'

  # Defines the root path route ("/")
  root "home#index"
end
