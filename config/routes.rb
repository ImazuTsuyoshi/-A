Rails.application.routes.draw do

  get 'bases/new'
  get 'bases/addition' , to: 'bases#addition'
  
  

  root 'static_pages#top'
  get '/signup', to: 'users#new'
  get 'users/index_attendace' , to: 'users#index_attendace'
  get 'users/correction_log' , to: 'users#correction_log'
 
  
  # ログイン機能 #
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  resources :users do
    collection { post :import }
    member do
      get 'edit_basic_info'
      patch 'update_basic_info'
      get 'attendances/edit_one_month'
      patch 'attendances/update_one_month'
    end
    
    resources :attendances do
      member do
        patch 'update'
        get 'edit_approval'
        patch 'update_approval'
        get 'edit_change'
        patch 'update_change'
        get 'edit_overtime'
        patch 'update_overtime'
        get 'edit_request_overtime'
        patch 'update_request_overtime'
      end
    end 
    
    resources :approvals, only: :update
  end
    

  
  resources :bases do
    member do
      get 'edit_basic_info'
      patch 'update_basic_info'
    end 
  end
  
  



  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end





