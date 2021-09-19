class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      user.create_invitation_digest
      log_in user
      flash[:success] = "会員登録完了です！"
      # redirect_to new_post_path
      redirect_to user_path(user)
    elsif user.activated? && !user.authenticated?(:activation, params[:id])
      flash[:danger] = "「本登録済み」かつ「リンクが不適切」です"
      redirect_to "/introduction"
    elsif user.activated?
      flash[:danger] = "「本登録済み」です"
      redirect_to "/introduction"
    elsif !user.authenticated?(:activation, params[:id])
      flash[:danger] = "「リンクが不適切」です"
      redirect_to "/introduction"
    else
      flash[:danger] = "予期せぬエラーが起こりました"
      redirect_to "/introduction"
    end

  end

end
