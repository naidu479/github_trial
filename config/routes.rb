Rails.application.routes.draw do

  devise_for :users
  # Engines

  # root

  # Api
  namespace :api do 
    namespace :v1 do 
      resources :posts do
      end
    end
  end
  # Api End

  #Devise Routes For Api
  devise_scope :user do
    delete '/logout', :to => 'api/v1/users/sessions#destroy'
    post '/login', :to => 'api/v1/users/sessions#create'
    post '/signup', :to => 'api/v1/users/registrations#create'
  end


end
