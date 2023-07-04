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
  end

  scope '/users' do
    resources :albums
  end
  # ============================================

  get '/profile/:id', to: 'profile#show', as: 'view_profile'
  post 'profile/follow/:id', to: 'profile#follow', as: 'profile_follow'
  delete 'profile/unfollow/:id', to: 'profile#unfollow', as: 'profile_unfollow'
  # ============================================
  post 'like_photo/:id', to: 'home#like_photo', as: 'like_photo'
end