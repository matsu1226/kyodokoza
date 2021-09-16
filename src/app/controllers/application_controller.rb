class ApplicationController < ActionController::Base
  include SessionsHelper
  include CategoriesHelper
  include StatsHelper
  include RelationshipsHelper
  include PostsHelper

  private
    def logged_in_user
      unless logged_in?
        flash[:danger] = "ログインをしてください"
        redirect_to login_url
      end
    end

    def check_have_relationship
      if no_relationship
        flash[:danger] = "家族の登録をしてください"
        redirect_to user_path(current_user)
      end
    end

end
