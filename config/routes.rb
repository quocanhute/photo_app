Rails.application.routes.draw do
  # resources :albums
  # resources :photos
  get 'profile/show'
  devise_for :users,controllers:{
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  root to: "home#index"

  # ============================================
  scope '/admins', constraints: { role: 0 } do
    resources :users
  end

  scope '/users' do
    resources :photos
    resources :albums do
      member do
        delete '/:idKey',to: 'albums#delete_image_attachment', as: 'delete_image'
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
  post 'like_photo/:id', to: 'home#like_photo', as: 'like_photo'
  post 'like_album/:id', to: 'home#like_album', as: 'like_album'
end