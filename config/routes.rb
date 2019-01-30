Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/' => 'home#top'

  resources :users, only: %i(show)
  resources :brochures, only: %i(index create new update edit destroy show) do
    resources :days, only: %i(create update destroy) do
      resources :spots, only: %i(create update destroy)
    end
  end

end
