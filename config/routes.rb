Api::Application.routes.draw do

  resources :tickets

  resources :accounts

  devise_for :users

  resources :members

  resource :current_session

  resources :events do
    resources :events
  end

  root :to => 'welcome#index'

end
