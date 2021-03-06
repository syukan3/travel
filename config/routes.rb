Rails.application.routes.draw do
  get 'api/set_spot'
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/' => 'home#top'

  resources :users, only: %i(show)
  resources :brochures, only: %i(index create new update edit destroy show) do
    resources :members, only: %i(index create)
    resources :days, only: %i(create update edit destroy) do
      put 'higher'
      put 'lower'
      resources :spots, only: %i(create update edit destroy) do
        put 'higher'
        put 'lower'
      end
    end
  end

  namespace :api do
    resources :spots, only: %i(create)
  end

end
