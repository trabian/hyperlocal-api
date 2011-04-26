Api::Application.routes.draw do

  resources :tickets

  resources :accounts

  devise_for :users

  resources :users do
    resources :tickets
  end

  # scope "/users" do
  #   resources :groups do
  #     resources :tickets
  #   end
  # end

  resources :members do
    resources :tickets
    resources :events
  end

  resources :tags do
    resources :tickets
  end

  resource :current_session

  resources :tickets do
    resources :comments
  end

  resources :events do
    resources :events
  end

  root :to => 'welcome#index'

end
