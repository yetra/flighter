Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    resources :users, only: [:index, :show, :create, :update, :destroy]

    resources :companies, only: [:index, :show, :create, :update, :destroy]

    resources :flights, only: [:index, :show, :create, :update, :destroy]

    resources :bookings, only: [:index, :show, :create, :update, :destroy]

    resource :session, only: [:create, :destroy]
  end
end
