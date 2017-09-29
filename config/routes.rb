Rails.application.routes.draw do

  devise_for :users

  get 'welcome/index'

  root 'welcome#index'

  get 'perform_backups/do_perform', to: 'perform_backups#do_perform'

  resources :perform_backups

  resources :courses do
    collection do
      match 'search' => 'courses#search', via: [:get, :post], as: :search
    end
  end

  resources :unite_groups do
    collection do
      match 'add/:id/:group_id' => 'unite_groups#add', via: [:get, :post], as: :add
      match 'remove/:id/:group_id' => 'unite_groups#remove', via: [:delete], as: :remove
      match 'search' => 'unite_groups#search', via: [:get, :post], as: :search
    end
  end

  resources :unite_matters do
    collection do
      match 'add/:id/:matter_id' => 'unite_matters#add', via: [:get, :post], as: :add
      match 'remove/:id/:matter_id' => 'unite_matters#remove', via: [:delete], as: :remove
      match 'search' => 'unite_matters#search', via: [:get, :post], as: :search
    end
  end

  resources :wishes, only: [:show, :new, :comments] do
    collection do
      match 'create/:option_id' => 'wishes#create', via: [:get, :post], as: :create
      match 'remove/:option_id' => 'wishes#remove', via: [:delete], as: :remove
    end
  end

  resources :options do
    collection do
      match 'search' => 'options#search', via: [:get, :post], as: :search
      match 'generate' => 'options#generate', via: [:get, :post], as: :generate
      match 'open_wish/:id' => 'options#open_wish', via: [:get, :post], as: :open_wish
      match 'open_comment/:id_wish' => 'options#open_comment', via: [:get, :post], as: :open_comment
    end
  end

  resources :schedules, only: [:new, :show] do
    collection do
      match 'create/:id_group' => 'schedules#create', via: [:get, :post], as: :create
      match 'remove/:id_group/:id' => 'schedules#remove', via: [:delete], as: :remove
    end
  end

  resources :messages, only: [:destroy, :new] do
    collection do
        match 'create/:id_ficha' => 'messages#create', via: [:get, :post], as: :create
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

  resources :users, controller: 'users' do
    collection do
      match 'search' => 'users#search', via: [:get, :post], as: :search
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
