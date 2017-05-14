Rails.application.routes.draw do
  root "fields#index"

  resources :fields
end
