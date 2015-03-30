Dorsale::Engine.routes.draw do
  resources :addresses
  resources :comments, only: [:create]
end
