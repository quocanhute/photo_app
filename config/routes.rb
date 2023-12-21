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
    resources :users
  end

  # action user
  scope '/users' do
    resources :posts do
      member do
        patch :vote
        patch :bookmark
        post :unpublish
        post :publish
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
      get :show_video
      post :added_tag
    end
  end
  resources :profile, only:  [:show] do
    member do
      post :follow
      delete :unfollow
    end
  end
  resources :dashboard do
    collection do
      # get :user_followers
      get :following_tags
      get :following_users
      get :posts_bookmark
    end
  end

  # action search
  post 'search/suggestions', to: 'search#suggestions', as: 'search_suggestions'
  get 'search', to: 'search#search_all', as: 'search_all'
  get 'show_all_user_search', to: 'search#show_all_user_search', as: :show_all_user_search

  # View Object Notification
  get '/notification/:id', to: 'notification#view_object', as: 'view_object'
end