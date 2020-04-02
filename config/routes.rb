Rails.application.routes.draw do
  devise_for :users
  get 'map/map'
  get 'home/home'
  get 'home/contact'

  # App Root
  root 'home#home'

  # Omniauth Redirect
  get '/auth/:provider/callback' => 'home#omniauth'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
