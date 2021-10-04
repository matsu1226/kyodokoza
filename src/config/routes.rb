Rails.application.routes.draw do
  match '(*any)', to: redirect(subdomain: ''), via: :all, constraints: {subdomain: 'www'}
  root 'static_pages#introduction'
  get  '/introduction', to: 'static_pages#introduction'
  get  '/terms', to: 'static_pages#terms'
  get  '/privacy_policy', to: 'static_pages#privacy_policy'
  get '/guest_sign_in', to: 'static_pages#guest_sign_in'

  
  get    '/login',     to: "sessions#new"
  post   '/login',     to: "sessions#create"
  delete '/logout',    to: "sessions#destroy"
  
  get 'stats/month'
  get 'stats/year'
  get 'stats/month_ajax'
  get 'stats/year_ajax'

  get 'report/single'
  get 'report/multiple'
  get 'report/output_multiple'

  # post '/callback', to: 'linebot#callback'

  get    '/posts/narrow_down'   # post/index を ajaxで絞り込み
  resources :posts, except: [:show]
  resources :incomes, except: [:show, :index]
  post    '/fixed_costs/exec'   # 
  resources :fixed_costs, except: [:show]
  
  get    '/signup',    to: "users#new"  
  resources :users , except: [:index, :destroy]
  resources :categories 
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  get    '/relationships/invitation_code', to: "relationships#invitation_code"
  resources :relationships,       only: [:new, :create] 
end

# resources :users の内容
# HTTPリクエスト	URL	アクション	名前付きルート	    用途
# GET	    /users/1	    show	  user_path(user)	      特定のユーザーを表示するページ
# GET	    /users/new	  new	    new_user_path	        ユーザーを新規作成するページ（ユーザー登録）
# POST	  /users	      create	users_path	          ユーザーを作成するアクション(メール送信)
# GET	    /users/1/edit	edit	  edit_user_path(user)	id=1のユーザーを編集するページ
# PATCH	  /users/1	    update	user_path(user)	      ユーザーを更新するアクション
# DELETE	/users/1	    destroy	user_path(user)	      ユーザーを削除するアクション
