Rails.application.routes.draw do
  root 'home#index'

  post 'battleship', to: 'battleship#initialize_game'
  put 'battleship', to: 'battleship#attack'

  resources :battleship
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
