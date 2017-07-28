Rails.application.routes.draw do

  resources :contacts
  devise_for :users

  get 'welcome/index'

  root 'welcome#index'


  get 'help/index'

  resources :users, controller: 'users' do
    collection do
      match 'search' => 'users#search', via: [:get, :post], as: :search
      match 'teachers', :to => 'users#teachers', via: [:get], as: :teachers
      match 'teachers/search' => 'users#teacher_search', via: [:get, :post], as: :teacher_search
    end
  end

  resources :fichas do
    collection do
      match 'search' => 'fichas#search', via: [:get, :post], as: :search
      match "copy/:id/:copy_id" , :to => "fichas#copy", via: [:get, :post], :as => 'copy'
    end
  end

  resources :matters do
    collection do
      match 'search' => 'matters#search', via: [:get, :post], as: :search
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
