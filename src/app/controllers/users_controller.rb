class UsersController < ApplicationController

  before_action :logged_in_user, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:show, :edit, :update, :destroy]


  def new
    @user = User.new
  end


  def create
    @user = User.new(user_params)
    @non_activated_user = User.find_by(email: params[:user][:email])

    # 入力したアドレスのユーザーがDBに存在し、activateされていないなら、
    if @non_activated_user && @non_activated_user.activated == false
      if @non_activated_user.update(user_params)
        @user = @non_activated_user 

        @user.send_activation_email
        flash[:info] = "仮登録メールを送信しました。確認してください。"
        redirect_to root_url
      else
        redirect_to new_user_path
        flash[:warning] = "フォームの入力値が不適切です"
      end
    elsif @user.save
      @user.send_activation_email
      flash[:info] = "仮登録メールを送信しました。確認してください。"
      redirect_to root_url
    else
      render action: :new
    end
    
  end

  
  def show
    @user = User.find(params[:id])
    if @relationship = @user.relationship
      @to_user = @relationship.users.where.not(id: params[:id]).first
      today = Date.today
      posts = Post.where(user_id: @relationship.user_ids).order(updated_at: :desc).limit(5)
      incomes = Income.where(user_id: @relationship.user_ids).order(updated_at: :desc).limit(5)
      @feed_items = posts | incomes
      @feed_items.sort!{ |a, b| a.updated_at <=> b.updated_at }
      @feed_items.reverse!.pop(5)
    end

    @share_url = "http%3A%2F%2Fwww.kyodokoza.com%2F"
    # @share_text = "夫婦やカップルで家計管理 | 共同口座専用の家計簿アプリ「キョウドウコウザ」"
    @share_text = "%E5%A4%AB%E5%A9%A6%E3%82%84%E3%82%AB%E3%83%83%E3%83%97%E3%83%AB%E3%81%A7%E5%AE%B6%E8%A8%88%E7%AE%A1%E7%90%86+%7C+%E5%85%B1%E5%90%8C%E5%8F%A3%E5%BA%A7%E5%B0%82%E7%94%A8%E3%81%AE%E5%AE%B6%E8%A8%88%E7%B0%BF%E3%82%A2%E3%83%97%E3%83%AA%E3%80%8C%E3%82%AD%E3%83%A7%E3%82%A6%E3%83%89%E3%82%A6%E3%82%B3%E3%82%A6%E3%82%B6%E3%80%8D"
    @hash_tag = "家計簿アプリ,夫婦,カップル"
  end

  def edit
    @user = User.find_by(id: params[:id])
  end

  def update
    @user = User.find_by(id: params[:id])
    @user.attributes = { name: params[:user][:name] }
    if @user.save(context: :except_password_change)
    # if @user.update(name: params[:user][:name])
      flash[:success] = "名前を変更しました！"
      redirect_to edit_user_path(@user)
    else
      render "edit"
    end
  end
  # updateのバリデーション => https://hene.dev/blog/2019/06/03/rails-validation

  # def destroy
  #   @user=User.find_by(id: params[:id])
  #   @user.destroy
  #   flash[:danger] = "アカウントを削除しました"
  #   redirect_to root_url
  # end


  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def user_params_name_only
      params.require(:user).permit(:name)
    end

    def correct_user
      @user = User.find(params[:id])
      unless current_user?(@user)
        redirect_to user_path(current_user) 
        flash[:warning] = "他のユーザーの情報は見ることができません"
      end
    end

end
