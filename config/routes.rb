Rails.application.routes.draw do
  get '/search', to: 'products#search'
  resources :products do
    resources :stocks, type: 'Stock'
    resources :stock_increments, controller: :stocks, type: 'StockIncrement'
    resources :stock_decrements, controller: :stocks, type: 'StockDecrement'
  end
  resources :calendar, only: %i[index]
  resources :bookings
  resources :schedules
  resources :services
  resources :professionals
  resources :customers
  resources :users, except: %i[new create]
  resource :identities, except: %i[new create]
  root 'calendar#index'

  match '/auth/:provider/callback', to: 'sessions#create', via: %i[get post]
  match '/logout', to: 'sessions#destroy', via: %i[get post]

  get '/bookings/:starts_at/new', to: 'bookings#new'
  get '/login', to: 'sessions#new'
  get '/auth/failure', to: 'sessions#failure'
  get '/calendar:start_date', to: 'calendar#index'
end
