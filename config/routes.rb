Rails.application.routes.draw do
  resources :drivers
  resources :homeowners
  devise_for :users
  get 'map', to:'map#map'
  get 'contact', to:'home#contact'

  # App Root
  root 'home#home'

  # Verification Form
  get 'verification', to:'verification#new'
  post 'verification', to:'verification#verify'

  # Omniauth Redirect
  get '/auth/:provider/callback' => 'home#omniauth'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
