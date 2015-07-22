Rails.application.routes.draw do
  root "home#home"

  mount Dorsale::Engine => "/dorsale"
end
