require 'sidekiq/web'
Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  get  '/check', to: 'application#service'
  post '/login', to: 'authentication#authenticate'
  
  resources :users#, only: [:index]

  namespace :admin do
    resources :users, only: [:index]
  end

  root to: 'application#service'

end
