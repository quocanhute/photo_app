Rails.application.routes.draw do
  root to: "home#index_show_photo"
  get 'profile/show'
  devise_for :users,controllers:{
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  # ============================================
  get '/photos', to: "home#index_show_photo", as: 'photos_index'
  get '/albums', to: "home#index_show_album", as: 'albums_index'
  # ============================================
  namespace 'admin' do
    resources :users
    resources :photos
    resources :albums
  end

  scope '/users' do
    resources :photos
    resources :albums do
      member do
        delete '/:id_key',to: 'albums#delete_image_attachment', as: 'delete_image'
      end
    end
  end
  # ============================================

  get '/profile/:id', to: 'profile#show', as: 'view_profile'
  post 'profile/follow/:id', to: 'profile#follow', as: 'profile_follow'
  delete 'profile/unfollow/:id', to: 'profile#unfollow', as: 'profile_unfollow'
  # ==============
  get '/profile/:id/photos', to: 'profile#show_photo', as: 'view_photos_user'
  get '/profile/:id/albums', to: 'profile#show_album', as: 'view_albums_user'
  get '/profile/:id/follower', to: 'profile#show_follower_user', as: 'view_follower_user'
  get '/profile/:id/followee', to: 'profile#show_followee_user', as: 'view_followee_user'
  # ==============
  # ============================================
  post 'like_photo/:id', to: 'photos#like_photo', as: 'like_photo'
  post 'like_album/:id', to: 'albums#like_album', as: 'like_album'
end