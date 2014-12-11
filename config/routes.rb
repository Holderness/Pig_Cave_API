Rails.application.routes.draw do

  resources :dreams, only: [:index]
  resources :thoughts, only: [:index]
  resources :stories, only: [:index]

end
