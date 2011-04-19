Api::Application.routes.draw do

  devise_for :users
  
  resources :users do
    resources :tickets
  end

  resources :members do
    resources :tickets
  end

  resource :current_session
  
  resources :tickets do
    resources :comments
  end

  root :to => 'welcome#index'

end
