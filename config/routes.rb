Twist::Application.routes.draw do
  devise_for :users

  root :to => "books#index"

  notes_routes = lambda do
    collection do
      get :completed
    end

    member do
      put :accept
      put :reject
      put :reopen
    end
    
    resources :comments
  end

  resources :books do
    member do
      post :receive
    end
    
    resources :chapters do
      resources :elements do
        resources :notes
      end
        
      resources :notes, &notes_routes
    end
    
    resources :notes, &notes_routes
  end
  
  get 'signed_out', :to => "users#signed_out"
end
