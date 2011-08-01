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

      resources :notes do
        resources :comments
      end
    end
    
    resources :notes
  end

  devise_for :users
  
  get 'signed_out', :to => "users#signed_out"
end
