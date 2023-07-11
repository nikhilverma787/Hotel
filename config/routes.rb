Rails.application.routes.draw do
  #landlord
  # post 'landlords/create'
  get 'landlord_login' => "landlords#login"
  post 'show_name' =>  "landlords#show_name"
  post 'landlord_show_by_location' => "landlords#show_by_location"
  post 'landlord_show_rooms_with_hotel' => "landlords#show_rooms_with_hotel"
  get "show_hotels" => "landlords#show_hotels"
  resource :landlords
  #customer
  #post 'customer/create'
  get 'customer_login' => 'customers#login'
  #post 'customer/update'
 # get 'customer/show'
  post 'customer_search_hotel_by_name' => "customers#search_hotel_by_name"
  post 'customer_show_rooms_with_hotel' => 'customers#show_rooms_with_hotel'
  post "customer_search_by_location" => "customers#search_by_location"
  get  "customer_booking" => "customers#customer_booking"
  post "show_booking_location" => "customers#show_booking_location"
  get "particular_detail/:id" => "customers#particular_detail"
  post "see_particular_room_wit_hotel" => "customers#see_particular_room_wit_hotel"
  resources :customers

  #motel
  resources :motels
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  #Rooms
  post "room_created_by_location" => "rooms#room_created_by_location"
  resources :rooms
  # Defines the root path route ("/")
  # root "articles#index"

  # post "bookings/create"
  resources :bookings

  #Location
  get "locations/show"


end
