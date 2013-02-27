# -*- encoding : utf-8 -*-
Bajiao::Application.routes.draw do

  scope :path => "/weixin", :via => :post, :defaults => {:format => 'xml'} do
    root :to => 'weixin/home#welcome', :constraints => Weixin::Router.new(:type => "text", :content => "Hello2BizUser")
    root :to => 'weixin/staffs#show', :constraints => Weixin::Router.new(:type => "text", :content => /^@/)
    root :to => 'weixin/staff_photos#update', :constraints => Weixin::Router.new(:type => "text", :content=>/^#photo /)
    root :to => 'weixin/staffs#index', :constraints => Weixin::Router.new(:type => "text")
    root :to => 'weixin/staff_photos#create', :constraints => Weixin::Router.new(:type => "image")
  end

  get "/weixin" => "weixin/home#show"

  resources :staffs
  resources :staff_photos

  namespace :admin do
    resources :staffs
    resources :weixin_users
    resources :staff_photos do
      member do
        post 'change_valid'
      end
    end

    match '/roster_reset/staff' => 'roster_reset#staff'
    match '/roster_reset/photo' => 'roster_reset#photo'

    resource :session

    match '/' => redirect("/admin/staffs")
  end

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
  # root :to => 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
