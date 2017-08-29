Rails.application.routes.draw do

  resources :wishes
  resources :options do
    collection do
      match 'search' => 'options#search', via: [:get, :post], as: :search
    end
  end

  resources :schedules, only: [:new, :show] do
    collection do
      match 'create/:id' => 'schedules#create', via: [:get, :post], as: :create
      match 'remove/:id_group/:id' => 'schedules#remove', via: [:delete], as: :remove
    end
  end

  resources :messages, only: [:destroy, :new] do
    collection do
        match 'create/:id' => 'messages#create', via: [:get, :post], as: :create
    end
  end

  resources :groups do
    collection do
      match 'schedule' => 'groups#schedule', via: [:get, :post], as: :schedule
      match 'search' => 'groups#search', via: [:get, :post], as: :search
    end
  end

  resources :contacts, only: [:new, :create] do
      collection do
        match 'help' => 'contacts#help', via: :get, as: :help
      end
  end

  devise_for :users

  get 'welcome/index'

  root 'welcome#index'

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
