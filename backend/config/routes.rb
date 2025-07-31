Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :invoices, only: [:index, :create]
      resources :payment_complements, only: [:create]
    end
  end
end
