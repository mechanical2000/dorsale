Dorsale::Engine.routes.draw do
  resources :addresses
  resources :comments, only: [:create]

  namespace :small_data do
    resources :filters, only: [:create]
  end
end
