OpengovernmentRoadtrip::Application.routes.draw do

  root to: redirect('api/v1/')
  
  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      root to: 'events#index'

      resources :events do 
        resources :comments
      end
      resources :comments
      resources :locations
      resources :authentication, only: [:create, :destroy]
      devise_for :users
      resources :users
      get "confirmations/:confirmation_token", to: 'confirmations#show'
    end
  end

end
