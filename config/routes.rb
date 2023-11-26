Rails.application.routes.draw do
  resources :tags

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

  # action admin
  namespace 'admin' do
    resources :users
    resources :photos
    resources :albums

  end

  # action user
  scope '/users' do
    resources :posts do
      resources :elements
      resources :comments, only: [:create]
      member do
        # patch :upvote
        # patch :downvote
        patch :vote
        patch :bookmark
      end
    end
    resources :photos
    resources :albums do
      member do
        # delete '/:id_key',to: 'albums#delete_image_attachment', as: 'delete_image'
      end
    end
  end

  # action publish post
  post 'posts/unpublish/:id', to: 'posts#unpublish', as: 'posts_unpublish'
  post 'posts/publish/:id', to: 'posts#publish', as: 'posts_publish'

  # action view profile
  get '/profile/:id', to: 'profile#show', as: 'view_profile'
  get '/profile/:id/photos', to: 'profile#show_photo', as: 'view_photos_user'
  get '/profile/:id/albums', to: 'profile#show_album', as: 'view_albums_user'
  get '/profile/:id/follower', to: 'profile#show_follower_user', as: 'view_follower_user'
  get '/profile/:id/followee', to: 'profile#show_followee_user', as: 'view_followee_user'

  # action follow
  post 'profile/follow/:id', to: 'profile#follow', as: 'profile_follow'
  delete 'profile/unfollow/:id', to: 'profile#unfollow', as: 'profile_unfollow'

  # action like
  post 'like_photo/:id', to: 'photos#like_photo', as: 'like_photo'
  post 'like_album/:id', to: 'albums#like_album', as: 'like_album'
  post 'like_comment/:id', to: 'comments#like_comment', as: 'like_comment'
  # action search
  post 'search/suggestions', to: 'search#suggestions', as: 'search_suggestions'
  get 'search', to: 'search#search_all', as: 'search_all'
  get 'show_all_user_search', to: 'search#show_all_user_search', as: :show_all_user_search
  get 'show_all_photo_search', to: 'search#show_all_photo_search', as: :show_all_photo_search
  get 'show_all_album_search', to: 'search#show_all_album_search', as: :show_all_album_search
end