Roommate::Application.routes.draw do
  resources :houses
  resources :expenses
  resources :payments
  resources :people do
    collection do
      post :search
      post :add_roommate
    end
  end
  resources :signups

  match 'wizard/house' => 'wizard#house', :as => :house_wizard, :via => :get

  match 'logout' => 'sessions#destroy', :as => :logout
  match 'login' => 'sessions#new', :as => :login
  # match 'register' => 'people#create', :as => :register
  # match 'signup' => 'people#signup', :as => :signup, :via => :post
  match 'account' => 'people#show', :as => :account
  match 'account_save' => 'people#update', :as => :account_save
  match 'account_save_password' => 'people#update_password', :as => :account_save_password
  # match 'thank_you' => 'dashboard#thank_you', :as => :thank_you
  resource :session, :only => [:new, :create, :destroy]
  match 'dashboard' => 'dashboard#index', :as => :dashboard

  match 'mobile/loans/:id(.:format)' => 'dashboard#mobile'

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
  root :to => 'pages#home'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
