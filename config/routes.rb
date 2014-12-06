Rails.application.routes.draw do

  resources :dreams, only: [:index]

end
