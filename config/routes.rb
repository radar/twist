Twist::Application.routes.draw do

  root :to => "books#index"
  resources :books do
    member do
      post :receive
    end
    
    resources :chapters do
      resources :elements do
        resources :notes
      end

      resources :notes
    end
  end

  devise_for :users
end
