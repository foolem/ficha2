Rails.application.routes.draw do

  devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }
  resources :users, controller: 'users' do
    collection do
      match 'search' => 'users#search', via: [:get, :post], as: :search

      match 'teachers' => 'users#teachers', via: [:get], as: :teachers
    end
  end

  resources :fichas do
    collection do
      match 'search' => 'fichas#search', via: [:get, :post], as: :search
    end
  end

  get 'welcome/index'

  root 'welcome#index'

  resources :matters
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
