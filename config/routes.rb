Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  root "blog#index"

  namespace :admin do
    scope :home do
      get "/", to: "home#index", as: :home
    end

    resources :post do
      match "set_cover_image/:attachment_id", to: "post#set_cover_image", via: [ :get, :post ], as: :set_cover_image
    end

    resources :short_link
  end

  scope :b, as: :blog do
    get "/", to: "blog#index", as: :index
    get "/:path", to: "blog#post", as: :post
  end

  scope :s, as: :short_link do
    get "/:code", to: "short_link#redirect", as: :redirect
  end

  get :contact, to: "home#contact"
end
