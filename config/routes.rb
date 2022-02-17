Rails.application.routes.draw do
  resources :posts do
    member do
      get :cancel
    end
  end
  root 'sites#home'
  get :about, to: "sites#about"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
