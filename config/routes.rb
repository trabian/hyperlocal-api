Api::Application.routes.draw do

  devise_for :users

  resources :members

  resource :current_session

  root :to => 'welcome#index'

end
