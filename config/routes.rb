Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  namespace :api do
    namespace :v1 do
        resources :messages, only: [:create]
        resources :chatrooms, only: [:create, :index, :destroy, :show]
        resources :users, only: [:create, :index]
        resources :user_chatrooms, only: [:create, :destroy]

        get '/uchatrooms', to: 'chatrooms#uindex'
        post '/newdm', to: 'chatrooms#dmcreate'

        post "/login", to: "auth#create"
        delete "/logout", to: "auth#destroy"
        post "/signup", to: "users#create"
        post "/validate", to: "auth#validate"
      end
  end



end
