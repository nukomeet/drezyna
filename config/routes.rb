Myapp::Application.routes.draw do
  devise_for :users,
    path: "",
    controllers: { registrations: "registrations" },
    path_names: { sign_in: 'login', password: 'forgot', confirmation: 'confirm', unlock: 'unblock', sign_up: 'register', sign_out: 'signout'}
  as :user do
  end

  authenticated :user do
    root to: 'home#dashboard', as: :authenticated_root
  end
  unauthenticated :user do
    root to: 'home#index', as: :unauthenticated_root
  end

  root to: 'home#index'

  resources :users
end