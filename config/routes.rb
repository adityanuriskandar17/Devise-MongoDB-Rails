Rails.application.routes.draw do
  devise_for :users, controllers: {
        sessions: 'users/sessions',
        registrations: 'users/registrations'
      }
  namespace :api do
    namespace :v1 do
      resources :customers
      resources :insurance_products
      resources :asuransis
    end
  end
end
