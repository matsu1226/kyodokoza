class StaticPagesController < ApplicationController

  def introduction
  end

  def guest_sign_in
    user = User.find_by(email: 'guest@example.com') 

    log_in user

    redirect_to new_post_path
    flash[:success] = "ゲストユーザーとしてログインしました"
  end
end
