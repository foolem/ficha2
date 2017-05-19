Rails.application.routes.draw do

  devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }
  resources :users, controller: 'users'

  resources :fichas do
    collection do
      match 'search' => 'fichas#search', via: [:get, :post], as: :search
    end
  end

  get 'welcome/index'

  root 'welcome#index'

  resources :teachers do
    collection do
      match 'search' => 'teachers#search', via: [:get, :post], as: :search
    end
  end

  resources :matters
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
