Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/' => 'home#top'
  get 'brochures/:brochure_id/days/:day_id/spots/:id/higher' => 'spots#spot_higher'

  resources :users, only: %i(show)
  resources :brochures, only: %i(index create new update edit destroy show) do
    resources :members, only: %i(index create)
    resources :days, only: %i(create update edit destroy) do
      resources :spots, only: %i(create update edit destroy)
    end
  end
  # resources :members, only: %i(create destroy)

end
