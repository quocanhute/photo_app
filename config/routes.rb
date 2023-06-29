Rails.application.routes.draw do
  get 'profile/show'
  devise_for :users,controllers:{
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  root to: "home#index"
  scope '/admin', constraints: { role: 0 } do
    resources :users
  end
  get '/profile/:id', to: 'profile#show', as: 'view_profile'
  post 'profile/follow/:id', to: 'profile#follow', as: 'profile_follow'
  delete 'profile/unfollow/:id', to: 'profile#unfollow', as: 'profile_unfollow'
end