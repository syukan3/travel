Rails.application.routes.draw do
  resources :brochures
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/' => 'home#top'

  resources :users, only: %i(show)
  # resources :users, only: %i(index create new update edit destroy)

end
