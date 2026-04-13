Rails.application.routes.draw do
  # Administrators
  namespace :administrators do
    root to: "administrators#index"
    resources :administrators do
        get "export_csv", on: :collection
      end
  end
  devise_for :administrators, path: "administrators"
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }
  namespace :users do
    resource :current_user, only: [ :update ], controller: "current_user"
  end
  resources :friendships, only: %i[index create destroy] do
    member do
      patch :accept
      patch :decline
    end
  end

  mount Tybo::Engine => "/tybo"
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
