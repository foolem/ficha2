Rails.application.routes.draw do

  devise_for :users
  resources :fichas
  get 'welcome/index'

  root 'welcome#index'
  
  resources :teachers
  resources :matters
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
