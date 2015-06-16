Dorsale::Engine.routes.draw do
  resources :comments, only: [:create, :update, :destroy]

  namespace :small_data do
    resources :filters, only: [:create]
  end

  namespace :alexandrie do
    resources :attachments, only: [:create, :destroy]
  end
end
