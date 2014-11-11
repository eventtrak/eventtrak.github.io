Rails.application.routes.draw do
  root 'events#test'
  resources :events
end
