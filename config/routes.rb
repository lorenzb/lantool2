LanTool2::Application.routes.draw do
  #root :to => 'lan#register'
  root :to => 'polls#index'

  match 'lan'   => 'lan#register'
  match 'lan/participants' => 'lan#participants'
  match 'lan/mailinglist'  => 'lan#mailinglist'
  match 'register' => 'lan#register'
  match 'faq'   => 'lan#faq'
  match 'games' => 'lan#games'
  
  resources :users do
    resources :attendances do
      resources :lan
    end
  end

  resources :lans, :controller => 'lan' do
    resources :attendances do
      resources :users
    end
  end

  get 'login'  => 'sessions#new',     :as => 'login'
  get 'logout' => 'sessions#destroy', :as => 'logout'
  get 'signup' => 'users#new',        :as => 'signup'
  
  match 'admin' => 'admin#index'
  match 'admin/manage_attendances' => 'admin#manage_attendances'
  put 'admin/update_attendances' => 'admin#update_attendances'
  match 'admin/finances' => 'admin#finances'
  put 'admin/:id/update_finances' => 'admin#update_finances', :as => 'update_finances'
  match 'admin/send_invoices' => 'admin#send_invoices'
  match 'admin/calculate_attendance_fees' => 'admin#calculate_attendance_fees'

  # create new poll (1. choose type, 2. input details (general form + ev. additional fields))
  match 'polls/new_type' => 'polls#choose_new_type', :as => 'new_poll'
  post 'polls/new' => 'polls#new'

  match 'polls/:id/vote' => 'polls#vote', :as => 'vote_poll'
  put 'polls/:id/receive_vote' => 'polls#receive_vote'
  resources :sessions
  resources :games
  resources :faqs, :path => 'faq' 
  resources :polls, :except => [:new]

  resources :mailinglists, :only => [:new, :create, :destroy], :path => 'mailinglist'
  match 'mailinglist' => 'mailinglists#new'
  match 'mailinglist(s)/confirm_delete' => 'mailinglists#confirm_delete', :as => :mailinglist_remove
  match 'mailinglist/manage' => 'mailinglists#manage'
  match 'mailinglist/import' => 'mailinglists#import'
  match 'mailinglist/receive_import' => 'mailinglists#receive_import'
  match 'mailinglist/send_message' => 'mailinglists#send_message' 
  match 'migration' => 'migration#index'
  match 'export' => 'migration#export'
  match 'import' => 'migration#import'

  match 'activity' => 'activity#plot'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
