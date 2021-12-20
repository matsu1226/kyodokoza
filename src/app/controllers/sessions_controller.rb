class SessionsController < ApplicationController
  def new
    if logged_in?
      redirect_to user_path(current_user)
      flash[:warning] = '既にログインしています'
    end
  end

  def create
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_to(user_path(user))
        # if user.relationship.nil?
        #   redirect_to user_path(user)
        # else
        #   redirect_to new_post_path
        # end
        flash[:success] = 'ログインに成功しました'
      else
        message = 'アカウントが本登録されていません'
        message += 'メールの本登録リンクをクリックしてください'
        flash[:danger] = message
        redirect_to introduction_url
      end
    else
      flash[:danger] = 'パスワードとメールアドレスの組合せが間違っています'
      render 'new'
    end
  end

  def destroy
    guest = User.find_by(email: 'guest@example.com')
    Category.where(relationship_id: guest.relationship.id).each { |category| category.destroy } if current_user == guest

    log_out if logged_in?
    redirect_to login_path
    flash[:success] = 'ログアウトしました。'
  end
end
