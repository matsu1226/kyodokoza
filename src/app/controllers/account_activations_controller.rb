class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      set_invitation_digest
      log_in user
      flash[:success] = "会員登録完了です！"
      # redirect_to new_post_path
      redirect_to user_path(user)
    else
      flash[:danger] = "本登録へのリンクが不適切です"
      redirect_to "/introduction"
    end

  end

end
