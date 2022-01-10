
Rails.application.routes.draw do
  require 'sidekiq/web'
  # sidekiq
  mount Sidekiq::Web, at: '/sidekiq'

  # letter_opener
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: '/letter_opener'
  end

  # redirect
  match '(*any)', to: redirect(subdomain: 'www'), via: :all, constraints: {subdomain: ''}
  
  
  # paths
  root 'static_pages#introduction'

  get  '/introduction',   to: 'static_pages#introduction'
  get  '/terms',          to: 'static_pages#terms'
  get  '/privacy_policy', to: 'static_pages#privacy_policy'
  
  get    '/login',         to: "sessions#new"
  post   '/login',         to: "sessions#create"
  delete '/logout',        to: "sessions#destroy"
  get    '/guest_sign_in', to: 'sessions#guest_sign_in'
  
  get 'stats/month'
  get 'stats/year'
  get 'stats/month_ajax'
  get 'stats/year_ajax'

  get 'report/single'
  get 'report/multiple'
  get 'report/output_multiple'

  get    '/posts/narrow_down'   # post/index を ajaxで絞り込み
  resources :posts, except: [:show]
  resources :incomes, except: [:show, :index]

  post    '/fixed_costs/exec'
  resources :fixed_costs, except: [:show]
  
  get  '/signup',    to: "users#new"
  resources :users , except: [:index, :destroy] do
    patch 'change_send_mail', on: :member  # 今後配信メールが増えるたびに対応しやすいよう、updateメソッドから切り出す
  end

  resources :categories 
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]

  get    '/relationships/invitation_code', to: "relationships#invitation_code"
  resources :relationships,       only: [:new, :create] 

  get '*path', controller: 'application', action: 'error_404'

end