class SessionsController < ApplicationController
  def new
    return unless logged_in?

    redirect_to user_path(current_user)
    flash[:warning] = '既にログインしています'
  end

  def create
    user = User.find_by(email: params[:session][:email])
    if user&.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_to(user_path(user))
        flash[:success] = 'ログインに成功しました'
      else
        message = "アカウントが本登録されていません \n メールの本登録リンクをクリックしてください"
        flash[:danger] = message
        redirect_to introduction_url
      end
    else
      flash[:danger] = 'パスワードとメールアドレスの組合せが間違っています'
      render 'new'
    end
  end

  def destroy
    guest = User.find_by(email: 'guest_1@example.com')
    if current_user == guest
      Category.destroy_for_guest(current_user, guest)
      redirect_to root_path
    else
      redirect_to login_path
    end
    log_out if logged_in?
    flash[:success] = 'ログアウトしました。'
  end

  def guest_sign_in
    guest1 = User.guest(1)
    guest2 = User.guest(2)
    common_guest = User.guest("common")

    @relationship = Relationship.find_or_create_by!(name: 'ゲスト用家族')

    [guest1, guest2, common_guest].each do |u|
      UserRelationship.find_or_create_by!(user_id: u.id, relationship_id: @relationship.id)
    end

    category_1 = Category.for_guest('固定費', '#ff4500', '家賃、光熱費など', @relationship.id, 150_000)
    category_2 = Category.for_guest('食費', '#ffd700', 'スーバー、外食など', @relationship.id, 36_000)
    category_3 = Category.for_guest('通信費', '#0000cd', '携帯代、wifi', @relationship.id, 10_000)
    category_4 = Category.for_guest('雑費','#800080', '洋服など', @relationship.id, 20_000)
    # guest_category5
    Category.for_guest('飲み会','#4169e1', '', @relationship.id, 20_000)

    Post.for_guest('家賃', 100_000, category_1, common_guest)
    Post.for_guest('サトウココノカドー', 6000, category_2, guest1)
    Post.for_guest('携帯', 4000, category_3, guest2)
    Post.for_guest('携帯', 3800, category_3, guest1)
    Post.for_guest('カツモトキヨシ', 1200, category_4, guest2)

    FixedCost.for_guest('奨学金', 12800, category_4, guest1, 27)

    log_in guest1

    redirect_to user_path(guest1)
    flash[:success] = 'ゲストユーザーとしてログインしました'
  end
end
