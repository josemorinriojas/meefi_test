Rails.application.routes.draw do
  resources :invoices, only: [:index, :create]
end
