Rails.application.routes.draw do
  resources :products do
    resources :stocks, type: 'Stock'
    resources :stock_increments, controller: :stocks, type: 'StockIncrement'
    resources :stock_decrements, controller: :stocks, type: 'StockDecrement'
  end
  resources :calendar, only: %i[index]
  resources :service_bookings
  resources :schedules
  resources :services
  resources :professionals
  resources :customers
  resources :users, except: %i[new create]
  resource :identities, except: %i[new create]
  root 'calendar#index'

  match '/auth/:provider/callback', to: 'sessions#create', via: %i[get post]
  match '/logout', to: 'sessions#destroy', via: %i[get post]

  get '/service_bookings/:booking_date/new', to: 'service_bookings#new'
  get '/login', to: 'sessions#new'
  get '/auth/failure', to: 'sessions#failure'
end
