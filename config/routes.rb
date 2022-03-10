Rails.application.routes.draw do
  root 'users#index'
  resources :users, except: %i[new create]
  resource :identities

  match '/auth/:provider/callback', to: 'sessions#create', via: %i[get post]
  get '/login', to: 'sessions#new'
  get '/auth/failure', to: 'sessions#failure'
  match '/logout', to: 'sessions#destroy', via: %i[get post]
end
