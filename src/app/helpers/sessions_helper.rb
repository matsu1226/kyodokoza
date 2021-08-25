module SessionsHelper
  #application_controllerにinclude

  def log_in(user)
    session[:user_id] = user.id
    # ブラウザ内の一時cookiesに暗号化済みのuser_idが自動で作成されます。
    # この後のページで、session[:user_id]を使ってuser_idを元通りに取り出すことができます。
  end

  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

end
