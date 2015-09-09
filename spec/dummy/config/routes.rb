Rails.application.routes.draw do
  devise_for :users
  root "home#home"

  mount Dorsale::Engine => "/dorsale"
end
