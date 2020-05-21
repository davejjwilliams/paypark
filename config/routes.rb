Rails.application.routes.draw do

  resources :withdrawal_requests
  resources :bookings, :except => [:edit]

  # Rate Button
  post 'rate', to: 'bookings#rate'

  # Booking Time Search
  post 'timesearch', to: 'map#timesearch'
  post 'clearsearch', to: 'map#clearsearch'

  # Homeowner and Driver Booking Lists
  get 'homeowner_bookings', to: 'bookings#homeowner_bookings'
  get 'driver_bookings', to: 'bookings#driver_bookings'

  resources :drivers
  resources :homeowners
  devise_for :users
  get 'contact', to:'home#contact'
  post 'request_contact', to: 'home#request_contact'

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

  # Create Withdrawal Request
  post 'withdraw', to: 'withdrawal_requests#withdraw', as: 'withdraw'

  # Process Withdrawal Request
  post 'process_request', to: 'withdrawal_requests#process_request', as: 'process_request'

  # Resources for chat
  resources :conversations, only: [:create] do
    member do
      post :close
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
