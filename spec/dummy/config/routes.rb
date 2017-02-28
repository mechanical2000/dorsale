Rails.application.routes.draw do
  devise_for :users
  root "home#home"

  mount Agilibox::Engine => "/agilibox"
  mount Dorsale::Engine  => "/dorsale"
end
