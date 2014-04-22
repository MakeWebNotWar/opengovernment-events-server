OpengovernmentRoadtrip::Application.routes.draw do

  root to: redirect('api/v1/')
  
  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      root to: 'events#index'

      resources :events
      resources :locations
      resources :comments
      resources :authentication, only: [:create, :destroy]
      devise_for :users
      resources :users

    end
  end

end
