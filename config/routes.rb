OpengovernmentRoadtrip::Application.routes.draw do

  root to: redirect('api/v1/')
  
  namespace :api do
    namespace :v1 do
      root to: 'events#index'

      resources :datasets
      resources :events
      resources :locations
      resources :comments
      resources :login
      resources :users

    end
  end

end
