class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        if user.relationship.nil?
          redirect_to user_path(user)
        else
          redirect_to new_post_path
        end
        flash[:success] = "ログインに成功しました"
      else
        message = "アカウントが本登録されていません"
        message += "メールの本登録リンクをクリックしてください"
        flash.now[:danger] = message
        redirect_to introduction_url
      end
    else
      flash.now[:danger] = "パスワードとメールアドレスの組合せが間違っています"
      render "new"
    end
  end

  def destroy
    log_out
    redirect_to login_path
    flash[:success] = "ログアウトしました。"
  end
end
