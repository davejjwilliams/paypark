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

  post 'search', to: 'bookings#search'

  # Temporary error route
  get 'booking_error', to: 'home#booking_error'

  # Routes for scheduler
  get "data", :to=>"scheduler#get", :as=>"data"
  post "data(/:id)", :to => "scheduler#add"
  put "data/:id", :to => "scheduler#update"
  delete "data/:id", :to => "scheduler#delete"

  # Stripe routes
  scope '/charges' do
    post 'create', to: 'charges#create', as: 'charges_create'
    post 'refund', to: 'charges#refund', as: 'charges_refund'
    get 'cancel', to: 'charges#cancel', as: 'charges_cancel'
    get 'success', to: 'charges#success', as: 'charges_success'
  end

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
