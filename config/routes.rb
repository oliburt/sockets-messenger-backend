Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  namespace :api do
    namespace :v1 do
        resources :messages
        resources :chatrooms
        resources :users

        get '/uchatrooms', to: 'chatrooms#uindex'

        post "/login", to: "auth#create"
        delete "/logout", to: "auth#destroy"
        post "/signup", to: "users#create"
        post "/validate", to: "auth#validate"
      end
  end



end
