Rails.application.routes.draw do
  resources :product_items
  resources :carts
  resources :products
  devise_for :users
  get 'pages/home'
  # get 'welcome/index'
  # devise_for :admin_users, ActiveAdmin::Devise.config

  devise_for :admin_users, {
   :path=>:user,
   :controllers=>
    {:sessions=>"active_admin/devise/sessions",
     :passwords=>"active_admin/devise/passwords",
     :unlocks=>"active_admin/devise/unlocks",
     :registrations=>"active_admin/devise/registrations",
     :confirmations=>"active_admin/devise/confirmations"},
   :path_names=>{:sign_in=>"login", :sign_out=>"logout"},
   :sign_out_via=>[:delete, :get]
  }

  ActiveAdmin.routes(self)
  # devise_for :admin_users, path: '', path_names: { sign_in: 'login', sign_out: 'logout'}

  ActiveAdmin::Devise::SessionsController.class_eval do

   def after_sign_in_path_for(resource)
      if current_admin_user.role === "buyer" || current_admin_user.role === "seller" 
        "/products"
      elsif current_admin_user.role === "admin"
       "/admin"
      end
   end
   def after_sign_out_path_for(resource)
      '/admin'
   end
  end

  ActiveAdmin::Devise::RegistrationsController.class_eval do
    def after_sign_up_path_for(_resource)
      "/products"
    end
  end

  resources :brands
  resources :categories
  
  # root 'welcome#index'

  post 'carts/:id/make_order', to: 'carts#make_order', as: 'make_order'


   root 'products#index'

  # root 'products#index' 


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
