Audience::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.
  
  constraints subdomain: 'admin' do
    get '/', :to => 'admin#login', as: :admin_root
  end
  

  get '/landing', to: 'static_pages#landing', as: :landing

  get '/landing2', to: 'static_pages#landing2', as: :landing2
  get '/venues/page/:page', to: 'venues#index'


  #root 'static_pages#home_feature'
  root 'static_pages#landing2'


  post '/users/create_beta', to: 'users#create_beta', as: :users_create_beta
  post '/users/fb_login', to: 'users#fb_login', as: :users_fb_login
  post '/users/login', to: 'users#login', as: :users_login
  post '/user_analytics', to: 'user_analytics#create', as: :user_analytics_post

  put '/users/fb/:fbid', to: 'users#update_facebook', as: :users_update_facebook

  get '/my/tickets', to: 'users#tickets', as: :users_tickets
  get '/redeem', to: 'tickets#redeem', as: :redeem_tickets
  get '/code_status', to: 'tickets#check_code', as: :check_code
  put '/redeem', to: 'tickets#claim', as: :claim_ticket

  get '/logout', to: 'admin#logout', as: :logout
  get '/login', to: 'static_pages#login', as: :login

  post '/artists/login', to: 'artists#login', as: :artist_login

  #get '/venues' to: 'venues#bug_jar', as: :bug_jar

  get '/dylanowen', to: 'artists#dylan_owen', as: :dylan_owen
  get '/toneperignon', to: 'artists#tone_perignon', as: :tone_perignon
  get '/dylanowen/events/ithaca', to: 'events#ithaca', as: :ithaca_concert
  get '/dylanowen/events/before', to: 'events#before', as: :before
  get '/1', to: 'events#ithaca', as: :ithaca_concert_short
  get '/dylanowen/events/after', to: 'events#after', as: :ithaca_after
  get '/artist_template', to: 'artists#artist_template', as: :artist_template

  
  resources :tickets
  resources :transactions
  # resources :attendees
    
  resources :events
  post '/venues/start', to: 'venues#start'
  resources :venues
  resources :users
  
  resources :artists

  get '/random_string', to: 'static_pages#random_string', as: :random_string
  get '/error_code', to: 'static_pages#error_code', as: :error_sentence

  get '/:artist_route', to: 'artists#show', as: :artist_profile

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

  # get '/test' => 'static_pages#test', as: :test
end
