Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  resources :users, except: [:index, :show]
  resources :goal_integrations, except: [:show]

  root :to => 'landing#index'
end
