Rails.application.routes.draw do
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

  scope '/users/:userid' do
    resources :photos
  end
  # ============================================

  get '/profile/:id', to: 'profile#show', as: 'view_profile'
  post 'profile/follow/:id', to: 'profile#follow', as: 'profile_follow'
  delete 'profile/unfollow/:id', to: 'profile#unfollow', as: 'profile_unfollow'
end