Rails.application.routes.draw do
  get 'map/map'
  get 'home/home'
  get 'home/contact'

  root 'home#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
