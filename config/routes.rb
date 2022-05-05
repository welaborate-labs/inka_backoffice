Rails.application.routes.draw do
  resources :calendar, only: %i[index]
  resources :service_bookings
  resources :schedules
  resources :services
  resources :professionals
  resources :customers
  resources :users, except: %i[new create]
  resource :identities
  root 'calendar#index'

  match '/auth/:provider/callback', to: 'sessions#create', via: %i[get post]
  get '/login', to: 'sessions#new'
  get '/auth/failure', to: 'sessions#failure'
  match '/logout', to: 'sessions#destroy', via: %i[get post]
end
