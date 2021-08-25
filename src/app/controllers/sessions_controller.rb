class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        redirect_to user_url(current_user)
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

# --- !ruby/object:ActionController::Parameters
# parameters: !ruby/hash:ActiveSupport::HashWithIndifferentAccess
#   authenticity_token: it434iKIjwGprqMLcQtwq1sPEm089RSXMdmcFQhEsgbdZ9Ks2DkWPej0COwo3jHDmYyYPoghIHtN5TNmHkK2aA
#   session: !ruby/object:ActionController::Parameters
#     parameters: !ruby/hash:ActiveSupport::HashWithIndifferentAccess
#       email: shotaro@kyodokoza.com
#       password: example01
#     permitted: false
#   commit: ログイン
#   controller: sessions
#   action: create
# permitted: false