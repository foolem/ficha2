Rails.application.routes.draw do

  devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }
  resources :users, controller: 'users' do
    collection do
      match 'search' => 'users#search', via: [:get, :post], as: :search

      match 'teachers', :to => 'users#teachers', via: [:get], as: :teachers
      match 'teachers/search' => 'users#teacher_search', via: [:get, :post], as: :teacher_search
    end
  end

  resources :fichas do

    collection do

      match 'import/import' => 'fichas#import', via: [:get, :post], as: :import

      match 'importing/import' => 'fichas#importing', via: [:get, :post], as: :importing

      match 'reload/import' => 'fichas#reload', via: [:get, :post], as: :reload

      match 'search' => 'fichas#search', via: [:get, :post], as: :search

      match "copy/:id" , :to => "fichas#copy", via: [:get, :post], :as => 'copy'
    end

  end

  get 'welcome/index'

  root 'welcome#index'

  resources :matters
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
