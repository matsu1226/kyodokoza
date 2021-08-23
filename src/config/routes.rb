Rails.application.routes.draw do
  root 'static_pages#introduction'
  get '/introduction', to: 'static_pages#introduction'
  get '/signup',    to: "users#new"  
  
  resources :users
end

# resources :users の内容
# HTTPリクエスト	URL	アクション	名前付きルート	    用途
# GET	    /users	      index	  users_path	          すべてのユーザーを一覧するページ
# GET	    /users/1	    show	  user_path(user)	      特定のユーザーを表示するページ
# GET	    /users/new	  new	    new_user_path	        ユーザーを新規作成するページ（ユーザー登録）
# POST	  /users	      create	users_path	          ユーザーを作成するアクション(メール送信)
# GET	    /users/1/edit	edit	  edit_user_path(user)	id=1のユーザーを編集するページ
# PATCH	  /users/1	    update	user_path(user)	      ユーザーを更新するアクション
# DELETE	/users/1	    destroy	user_path(user)	      ユーザーを削除するアクション
