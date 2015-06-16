Dorsale::Engine.routes.draw do
  resources :comments, only: [:create]

  namespace :small_data do
    resources :filters, only: [:create]
  end

  namespace :alexandrie do
    resources :attachments, only: [:create, :destroy]
  end
end
