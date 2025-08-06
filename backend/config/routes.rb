require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  namespace :api do
    namespace :v1 do
      resources :invoices, only: [:index, :create] do
        member do
          get :download_file
        end
      end
      resources :payment_complements, only: [:create]
    end
  end
end
