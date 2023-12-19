Rails.application.routes.draw do
  root to: "home#index"
  # get '/:locale' => 'home#index'
  devise_for :users,controllers:{
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  # action home page
  get '/photos', to: "home#index_show_photo", as: 'photos_index'
  get '/albums', to: "home#index_show_album", as: 'albums_index'
  get '/posts', to: "home#index_show_post", as: 'posts_index'
  post '/posts', to: "home#index_show_post", as: 'get_post_index_pagy'


  # action admin
  namespace 'admin' do
    resources :users
    resources :photos
    resources :albums

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
    end
    resources :photos
    resources :albums
  end

  resources :chats do
    resources :messages
  end
  resources :tags do
    member do
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

  get '/profile/:id/albums', to: 'profile#show_album', as: 'view_albums_user'
  get '/profile/:id/follower', to: 'profile#show_follower_user', as: 'view_follower_user'
  get '/profile/:id/followee', to: 'profile#show_followee_user', as: 'view_followee_user'

  # action like
  post 'like_photo/:id', to: 'photos#like_photo', as: 'like_photo'
  post 'like_album/:id', to: 'albums#like_album', as: 'like_album'
  # action search
  post 'search/suggestions', to: 'search#suggestions', as: 'search_suggestions'
  get 'search', to: 'search#search_all', as: 'search_all'
  get 'show_all_user_search', to: 'search#show_all_user_search', as: :show_all_user_search
  get 'show_all_photo_search', to: 'search#show_all_photo_search', as: :show_all_photo_search
  get 'show_all_album_search', to: 'search#show_all_album_search', as: :show_all_album_search

  # View Object Notification
  get '/notification/:id', to: 'notification#view_object', as: 'view_object'
end