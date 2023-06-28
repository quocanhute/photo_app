Rails.application.routes.draw do
  devise_for :users,controllers:{
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  root to: "home#index"
  scope '/admin', constraints: { role: 0 } do
    resources :users
  end
  get '/users/:id', to: 'users#view_profile', as: 'view_profile'
end