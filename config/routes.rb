Rails.application.routes.draw do
  namespace :api, module: :api do
    resources :gift_cards, only: :show
  end

  resources :gift_cards
  resources :bills, only: %i[index show create edit]
  resources :products do
    resources :stocks, type: "Stock"
    resources :stock_increments, controller: :stocks, type: "StockIncrement"
    resources :stock_decrements, controller: :stocks, type: "StockDecrement"
  end
  resources :calendar, only: %i[index]
  resources :bookings
  resources :schedules
  resources :services do
    collection do
      get :search
    end
  end
  resources :professionals
  resources :customers do
    collection do
      get :search
    end
    resources :anamnesis_sheets, except: %i[index edit]
    get '/bookings/in_progress', to: 'bookings#in_progress'
  end
  resources :users, except: %i[new create]
  resource :identities, except: %i[new create]
  resources :reports, only: [:index]

  root "calendar#index"

  match "/auth/:provider/callback", to: "sessions#create", via: %i[get post]
  match "/logout", to: "sessions#destroy", via: %i[get post]

  get "/search", to: "products#search"
  get '/bookings/:starts_at/new', to: 'bookings#new'
  get '/login', to: 'sessions#new'
  get '/auth/failure', to: 'sessions#failure'
  get '/calendar:calendar_date', to: 'calendar#index'
  get '/calendar/professional_daily', to:'calendar#professional_daily'
  get '/calendar/professional_weekly', to:'calendar#professional_weekly'
  get '/calendar/adm', to:'calendar#adm'
  get '/customers/bookings/in_progress_all', to: 'bookings#in_progress_all'
  post '/:id/cancel_nfse', to: 'bills#cancel', as: '/cancel_nfse'
end
