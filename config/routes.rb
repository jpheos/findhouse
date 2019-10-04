Rails.application.routes.draw do
  get :results, to: 'pages#results'
  resources :cities, only: :show do
    collection do
      get :search
    end
    member do
      get :data
    end
  end
  get :select_stations, to: 'pages#select_stations'
  root to: 'pages#home'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
