Rails.application.routes.draw do

  resources :bookings
  resources :drivers
  resources :homeowners
  devise_for :users
  get 'contact', to:'home#contact'

  # Sign Up View
  get 'signup', to:'home#signup'

  # App Root
  root 'map#map'

  # Verification Form
  get 'verification', to:'verification#new'
  post 'verification', to:'verification#verify'

  # Omniauth Redirect
  get '/auth/:provider/callback' => 'home#omniauth'

  # Temporary live chat route
  get 'chat', to:'chat#chat'

  # Resources for chat
  resources :conversations, only: [:create] do
    member do
      post :close
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
