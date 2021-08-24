class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = "会員登録完了です！"
      # redirect_to new_post_path
      redirect_to "/introduction"
    else

    end

  end

end
