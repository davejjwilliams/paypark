Rails.application.routes.draw do

  resources :bookings
  resources :drivers
  resources :homeowners
  devise_for :users
  get 'contact', to:'home#contact'


  get "data", :to=>"bookings#get", :as=>"data"
  post "data(/:id)", :to => "bookings#add"
  put "data/:id", :to => "bookings#updateCal"
  delete "data/:id", :to => "bookings#delete"


  # Sign Up View
  get 'signup', to:'home#signup'

  # App Root
  root 'map#map'

  # Verification Form
  get 'verification', to:'verification#new'
  post 'verification', to:'verification#verify'

  # Omniauth Redirect
  get '/auth/:provider/callback' => 'home#omniauth'

  # Temporary error route
  get 'booking_error', to: 'home#booking_error'

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
