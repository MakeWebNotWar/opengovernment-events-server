OpengovernmentRoadtrip::Application.routes.draw do

  root to: redirect('api/v1/')
  
  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      root to: 'events#index'

      resources :events
      resources :comments
      resources :replies
      resources :locations
      resources :authentication, only: [:create, :destroy]
      devise_for :users
      resources :users
      resources :notifications 
      get "confirmations/:confirmation_token", to: 'confirmations#show'
      post "signup", to: 'signup#create'
    end
  end

end
