Rails.application.routes.draw do

  resources :unavailabilities, only: [:create, :destroy]

  resources :availabilities, only: [:create, :update] do
    collection do

      match 'user_availability' => 'availabilities#user_availability', via: [:get], as: :user_availability
      match 'add_unavailability/:id' => 'availabilities#add_unavailability', via: [:get], as: :add_unavailability
      match 'open_unavailability/:id' => 'availabilities#open_unavailability', via: [:get], as: :open_unavailability

      match 'open_availability_comments/:id' => 'availabilities#open_availability_comments', via: [:get], as: :open_availability_comments
      match 'add_availability_comments' => 'availabilities#add_availability_comments', via: [:get, :post], as: :add_availability_comments
      match 'change_comments/:id' => 'availabilities#change_comments', via: [:get], as: :change_comments

      match 'open_general_comments/:id' => 'availabilities#open_general_comments', via: [:get], as: :open_general_comments
      match 'add_general_comments' => 'availabilities#add_general_comments', via: [:get, :post], as: :add_general_comments
      match 'change_general_comments/:id' => 'availabilities#change_general_comments', via: [:get], as: :change_general_comments

      match 'is_researcher' => 'availabilities#is_researcher', via: [:get, :post], as: :is_researcher
      match 'change_researcher/:id' => 'availabilities#change_researcher', via: [:get, :post], as: :change_researcher

      match 'add_phone' => 'availabilities#add_phone', via: [:get, :post], as: :add_phone
      match 'change_phone/:id' => 'availabilities#change_phone', via: [:get, :post], as: :change_phone


      match 'select_preference/:id/:preference' => 'availabilities#select_preference', via: [:get], as: :select_preference
      match 'add_preference' => 'availabilities#add_preference', via: [:get, :post], as: :add_preference
      match 'change_preference/:id/:preference' => 'availabilities#change_preference', via: [:get], as: :change_preference

    end
  end

  devise_for :users

  get 'manage_options/index'
  get 'manage_options/generate'
  delete 'manage_options/remove'
  get 'manage_options/start'
  get 'manage_options/end'
  get 'manage_options/delivery'
  post 'manage_options/choose_teacher'

  match 'manage_options/select_teacher/:id' => 'manage_options#select_teacher', via: [:get, :post], as: :manage_options_select_teacher
  match 'manage_options/teacher_report' => 'manage_options#teacher_report', via: [:get], as: :manage_options_teacher_report
  match 'manage_options/matter_report' => 'manage_options#matter_report', via: [:get], as: :manage_options_matter_report
  match 'manage_options/final_report' => 'manage_options#final_report', via: [:get], as: :manage_options_final_report

  get 'welcome/index'

  root 'welcome#index'

  get 'perform_backups/update_cron', to: 'perform_backups#update_cron'
  get 'perform_backups/do_perform', to: 'perform_backups#do_perform'

  resources :perform_backups

  resources :courses do
    collection do
      match 'search' => 'courses#search', via: [:get, :post], as: :search
    end
  end

  resources :unite_groups do
    collection do
      match 'choose/:unite_group_id/:unite_matter_id' => 'unite_groups#choose', via: [:get, :post], as: :choose
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
      match 'open_wish/:id' => 'options#open_wish', via: [:get, :post], as: :open_wish
      match 'open_unavailability_comment/:id_wish' => 'options#open_unavailability_comment', via: [:get, :post], as: :open_unavailability_comment
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
