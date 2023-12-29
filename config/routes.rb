Rails.application.routes.draw do
  root to: "home#index"
  # get '/:locale' => 'home#index'
  devise_for :users,controllers:{
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  # action home page
  get '/posts', to: "home#index_show_post", as: 'posts_index'
  post '/posts', to: "home#index_show_post", as: 'get_post_index_pagy'
  get '/videos', to: "home#index_show_video", as: 'videos_index'
  post '/videos', to: "home#index_show_video", as: 'get_video_index_pagy'

  # action admin
  namespace 'admin' do
    get :index_ban_user, to: "users#index_ban_user"
    resources :users do
      member do
        get :action_ban_user
        get :action_unban_user
        post :ban_user
        post :unban_user
      end
    end
    resources :posts do
      member do
        get :action_accept_post
        get :action_refuse_post
        post :accept_post
        post :refuse_post
      end
    end
    resources :videos do
      member do
        get :action_accept_video
        get :action_refuse_video
        post :accept_video
        post :refuse_video
      end
    end
  end

  # action user
  scope '/users' do
    resources :posts do
      member do
        patch :vote
        patch :bookmark
        post :unpublish
        post :publish
        get :action_delete_post
      end
      resources :elements
      resources :comments, only: [:create, :destroy] do
        member do
          patch :vote
        end
      end
    end
    resources :videos do
      member do
        patch :vote
        patch :bookmark
        post :unpublish
        post :publish
        get :action_delete_video
      end
      resources :vcomments, only: [:create, :destroy] do
        member do
          patch :vote
        end
      end
    end
  end

  resources :chats do
    resources :messages
  end
  resources :tags do
    member do
      post :show, as: 'get_posts_tag_index_pagy'
      get :show_video
      post :show_video, as: 'get_videos_tag_index_pagy'
      post :added_tag
    end
  end
  resources :profile, only:  [:show] do
    member do
      post :follow
      delete :unfollow
      get :action_report_user
      post :report_user
    end
  end
  resources :dashboard do
    collection do
      # get :user_followers
      get :following_tags
      get :following_users
      get :posts_bookmark
      post :posts_bookmark, as: 'get_posts_dashboard_pagy'
      get :videos_bookmark
      post :videos_bookmark, as: 'get_videos_dashboard_pagy'
      get :notifications
    end
  end

  # action search
  post 'search/suggestions', to: 'search#suggestions', as: 'search_suggestions'
  get 'search', to: 'search#search_all', as: 'search_all'
  get 'show_all_user_search', to: 'search#show_all_user_search', as: :show_all_user_search

  # get 'error404', to: 'errors#not_found_404', as: 'error404'
  # get 'error403', to: 'errors#not_authen_403', as: 'error403'

  match "/404", via: :all, to: 'errors#not_found_404'
  match "/403", via: :all, to: 'errors#not_authen_403'
  # match "/422", to: "errors#unprocessable'" via: :all
  match "/500", via: :all, to: "errors#internal_server_error_500"
  # View Object Notification
  get '/notification/:id', to: 'notification#view_object', as: 'view_object'
end