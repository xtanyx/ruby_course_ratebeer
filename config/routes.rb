Rails.application.routes.draw do
  resources :styles
  resources :beer_clubs
  resources :users
  resources :beers
  resources :breweries
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  
  root 'breweries#index'
  get 'all_beers', to: 'beers#index'
  # get 'ratings', to: 'ratings#index'
  # get 'ratings/new', to: 'ratings#new'
  # post 'ratings', to: 'ratings#create'
  
  resources :ratings, only: [:index, :new, :create, :destroy]

  get 'signup', to: 'users#new'

  resource :session, only: [:new, :create, :destroy]

  get 'signin', to: 'sessions#new'
  delete 'signout', to: 'sessions#destroy'

  resources :memberships, only: [:index, :new, :create, :destroy]

  resources :places, only: [:index, :show]
  post 'places', to: 'places#search'
end
