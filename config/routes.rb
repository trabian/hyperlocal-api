Api::Application.routes.draw do

  devise_for :users
  
  resources :users do
    resources :tickets
  end
  
  scope "/users" do
    resources :groups do
      resources :tickets
    end
  end

  resources :members do
    resources :tickets
  end
  
  resources :tags do
    resources :tickets
  end

  resource :current_session
  
  resources :tickets do
    resources :comments
  end

  root :to => 'welcome#index'

end
