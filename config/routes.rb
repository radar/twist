Twist::Application.routes.draw do
  root :to => "books#index"
  resources :books

  devise_for :users
end
